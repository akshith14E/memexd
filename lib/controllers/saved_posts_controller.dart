import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/models/comment_model.dart';
import 'package:memexd/models/fetched_user_model.dart';
import 'package:memexd/models/post_model.dart';
import 'package:memexd/models/rating_model.dart';
import 'package:memexd/providers/auth_provider.dart';
import 'package:memexd/extensions/reatimeDBExtention.dart';

final savedPostsProvider =
    StateNotifierProvider<SavedPostsController, AsyncValue<List<Post>>>(
        (ref) => SavedPostsController(ref.read));

class SavedPostsController extends StateNotifier<AsyncValue<List<Post>>> {
  Reader _reader;
  List<Post>? get getPosts => state.data?.value;
  bool hasMorePosts = false;
  SavedPostsController(this._reader) : super(AsyncData([]));
  void sortPostsbySavedPosts(String id) async {
    PostFromDB postFromDB;
    Rating rating;
    FetchedUser fetchedUser;
    NoOfComments noOfComments = NoOfComments(tc: "");
    List<Post> postsSorted = [];
    state = AsyncLoading();
    final posts = await _fetchPostbySavedPosts(id);
    for (var post in posts) {
      postFromDB = PostFromDB.fromJson(post);

      var ratingFromDB = await _getRatingFromPostId(postFromDB.postId);
      rating =
          Rating(rating: ratingFromDB.value?.values?.first.toString() ?? "0");

      var cmCountFromDb = await _getCommentsNoFromPostId(postFromDB.postId);
      noOfComments =
          NoOfComments(tc: cmCountFromDb.value?.values.first.toString() ?? "0");

      var user = await _getPushblisherFromId(postFromDB.publisher);
      fetchedUser = FetchedUser.fromJson(user.value);

      postsSorted.add(Post(
        p: postFromDB,
        r: rating,
        u: fetchedUser,
        nc: noOfComments,
      ));
    }
    state = AsyncData([...postsSorted]);
  }

  _fetchPostbySavedPosts(String id) async {
    var posts = await _reader(firebaseDBProvider)
        .byChild('Posts')
        .orderByChild('postId')
        .equalTo(id)
        .once();
    return posts.value.values;
  }

  Future<DataSnapshot> _getRatingFromPostId(String postId) async {
    return await _reader(firebaseDBProvider)
        .byChild('Ratings')
        .child(postId)
        .once();
  }

  Future<DataSnapshot> _getCommentsNoFromPostId(String postId) async {
    return await _reader(firebaseDBProvider)
        .byChild("CommentCounts")
        .child(postId)
        .once();
  }

  Future<DataSnapshot> _getPushblisherFromId(String pubId) async {
    return await _reader(firebaseDBProvider)
        .byChild('Users')
        .child(pubId)
        .once();
  }
}
