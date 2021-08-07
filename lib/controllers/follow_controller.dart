import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/constants/stringX.dart';
import 'package:memexd/models/fetched_user_model.dart';
import 'package:memexd/models/user_model.dart';
import 'package:memexd/providers/auth_provider.dart';

import 'package:memexd/screens/profile_screen.dart';
import 'package:memexd/services/get_user_data.dart';

final followProvider =
    StateNotifierProvider<FollowController, AsyncValue<List<FetchedUser>>>(
        (ref) => FollowController());

class FollowController extends StateNotifier<AsyncValue<List<FetchedUser>>> {
  FollowController() : super(AsyncData([]));
  List<FetchedUser> followerList = [], followingList = [];
  get getData => state.data!.value;
  void setState(List<FetchedUser> list) {
    state = AsyncData(list);
  }

  initFollowing() async {
    state = AsyncLoading();
    var temp = await GetUserData().getLocalFollowingList();
    for (var i in temp) {
      final fetchUsers = await FirebaseDatabase.instance
          .reference()
          .child('Users')
          .child(i)
          .once();
      followingList.add(FetchedUser.fromJson(fetchUsers.value));
    }
    state = AsyncData(followingList);
  }

  initFollowers() async {
    state = AsyncLoading();
    await FirebaseDatabase.instance
        .reference()
        .child('Follow')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('followers')
        .once()
        .then((DataSnapshot snapshot) async {
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        for (var data in values.entries) {
          await FirebaseDatabase.instance
              .reference()
              .child('Users')
              .child(data.key)
              .once()
              .then((DataSnapshot snapshot) {
            followerList.add(FetchedUser.fromJson(snapshot.value));
          });
        }
      }
    });
    state = AsyncData(followerList);
  }

  getFollowing() {
    state = AsyncLoading();
    state = AsyncData(followingList);
  }

  getFollowers() {
    state = AsyncLoading();
    state = AsyncData(followerList);
  }

  // void show(List<FetchedUser> following) {
  //   for (FetchedUser user in following) {
  //     temporaryList.add(user);
  //   }
  //   state = following;
  // }
}
