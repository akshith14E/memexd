import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/models/post_model.dart';
import 'package:memexd/models/profile_user_model.dart';
import 'package:memexd/screens/profile_screen.dart';

class ProfileUserData extends StateNotifier<AsyncValue<ProfileUser>> {
  ProfileUserData(ProfileUser state) : super(AsyncData(ProfileUser()));

  Future<void> getData(String id) async {
    state = AsyncLoading();
    await FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(id)
        .onValue
        .listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        state = AsyncData(
          ProfileUser(
            followers: snapshot.value['tfrs'].toString(),
            name: snapshot.value['username'].toString(),
            bio: snapshot.value['bio'].toString(),
            following: snapshot.value['tflng'].toString(),
            post: snapshot.value['tpsts'].toString(),
            profilePicture: snapshot.value['imageUrl'],
          ),
        );
      } else {
        state = AsyncError(ProfileUser());
      }
    });
  }
}

class ProfileUserMemes extends StateNotifier<List<String>> {
  Reader _reader;
  ProfileUserMemes(this._reader) : super([]);

  Future<void> getPosts(String id) async {
    List<String> posts = [];
    await FirebaseDatabase.instance
        .reference()
        .child('Posts')
        .orderByChild("publisher")
        .equalTo(FirebaseAuth.instance.currentUser!.uid)
        .limitToLast(6)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        posts.add(values['postImage']);
      });
    });
    List<String> reversedList = new List.from(posts.reversed);
    state = reversedList;
  }
}

final profileUserDataNotifier =
    StateNotifierProvider<ProfileUserData, AsyncValue<ProfileUser>>((ref) {
  return ProfileUserData(ProfileUser());
});

final profileUserMemesNotifier =
    StateNotifierProvider<ProfileUserMemes, List<String>>((ref) {
  return ProfileUserMemes(ref.read);
});
