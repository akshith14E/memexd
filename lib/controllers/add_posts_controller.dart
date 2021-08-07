import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:memexd/constants/stringX.dart';
import 'package:memexd/models/post_model.dart';
import 'package:memexd/providers/auth_provider.dart';
import 'package:memexd/extensions/reatimeDBExtention.dart';
import 'package:memexd/services/image_upload.dart';

final addPostsProvider =
    StateNotifierProvider<AddPostController, AsyncValue<List<Post>>>(
        (ref) => AddPostController(ref.read));

class AddPostController extends StateNotifier<AsyncValue<List<Post>>> {
  Reader _reader;
  AddPostController(this._reader) : super(AsyncData([]));

  void addPosts(
      String caption, String? username, File path, String? templateKey) async {
    String? postURL = await uploadImageToFirebase(path);
    postURL = postURL!.replaceAll(stringX, "");

    String postId = _reader(firebaseDBProvider).byChild('Posts').push().key;
    final df = -1 * DateTime.now().millisecondsSinceEpoch;
    if (templateKey == null) {
      templateKey = "g";
    }

    return await _reader(firebaseDBProvider)
        .byChild('Posts')
        .child(postId)
        .set({
      "caption": caption,
      "postId": postId,
      "postImage": postURL,
      "publisher": FirebaseAuth.instance.currentUser!.uid,
      "time": df,
      "tr": 0,
      "trtrs": 0,
      "tu": templateKey
    });
  }

  increaseNumberOfMemes() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final dataRef = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(userId)
        .child('tpsts');
    dataRef.runTransaction((MutableData transaction) async {
      print(transaction.value);
      transaction.value = (transaction.value ?? 0) + 1;
      return transaction;
    });
  }
}
