import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/controllers/post_controller.dart';
import 'package:memexd/models/comment_model.dart';
import 'package:memexd/models/fetched_user_model.dart';
import 'package:memexd/providers/auth_provider.dart';
import 'package:memexd/extensions/reatimeDBExtention.dart';

final commentsProvider =
    StateNotifierProvider.family<CommentController, List<Comment>, String>(
        (ref, postId) {
  return CommentController(ref.read, postId);
});

final commentsStream = StreamProvider.family<Event, String>((ref, postId) {
  return ref.read(firebaseDBProvider).byChild("Comments").child(postId).onValue;
});

class CommentController extends StateNotifier<List<Comment>> {
  final Reader _reader;
  final String postId;
  StreamSubscription<Event>? _streamSubscription;
  CommentController(this._reader, this.postId) : super([]) {
    print(postId);
    _streamSubscription?.cancel();
    _streamSubscription =
        _reader(commentsStream(postId).stream).listen((event) async {
      final commentsFromDB = event.snapshot.value;
      final List<Comment> comments = [];
      if (commentsFromDB != null) {
        for (var comment in commentsFromDB.values) {
          var commentFromDB = CommentFromDB.fromJson(comment);
          var pub = await _getUserFromPubId(commentFromDB.pub);
          var fetchUser = FetchedUser.fromJson(pub.value);
          comments.add(Comment(c: commentFromDB, u: fetchUser));
        }
        state = [...comments];
      } else {
        state = [];
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
    print("disposed");
  }

  void addData({required String postId, required String comment}) async {
    _updateNoOfComments(postId);
    final currentUser = _reader(authServicesProvider).getCurrentUser()!;
    await _updateCommentsCollection(postId, comment, currentUser);
  }

  void deleteComment({required String commentId}) async {
    await _reader(firebaseDBProvider)
        .byChild("Comments")
        .child(postId)
        .child(commentId)
        .remove();
    final DatabaseReference _ref = _reader(firebaseDBProvider)
        .byChild("CommentCounts")
        .child(postId)
        .child("tc");
    _updateMutableData(_ref, -1);
  }

  Future<DataSnapshot> _getUserFromPubId(String pubId) async {
    return await _reader(firebaseDBProvider)
        .byChild("Users")
        .child(pubId)
        .once();
  }

  void _updateNoOfComments(postId) async {
    final DatabaseReference _ref = _reader(firebaseDBProvider)
        .byChild("CommentCounts")
        .child(postId)
        .child("tc");
    _updateMutableData(_ref, 1);
  }

  Future<void> _updateCommentsCollection(
      postId, comment, User currentUser) async {
    final commentId = _reader(firebaseDBProvider).reference().push().key;
    await _reader(firebaseDBProvider)
        .byChild("Comments")
        .child(postId)
        .child(commentId)
        .set(<String, String>{
      "cmnt": comment,
      "cmntId": commentId,
      "pub": currentUser.uid,
    });
  }

  _updateMutableData(DatabaseReference ref, dynamic value) async {
    final _transaction =
        await ref.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + value;
      return mutableData;
    });
    if (_transaction.committed) {
      await ref.set(_transaction.dataSnapshot?.value);
      final posts = _reader(postsProvider.notifier).getPosts;
      final changedPosts = posts?.map((e) {
        if (e.p.postId == postId) {
          e.nc = e.nc.copyWith(tc: _transaction.dataSnapshot?.value.toString());
        }
        return e;
      }).toList();
      _reader(postsProvider.notifier).setState(changedPosts);
    } else {
      if (_transaction.error != null) {}
    }
  }
}
