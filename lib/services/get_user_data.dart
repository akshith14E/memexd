import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:memexd/constants/cache_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetUserData {
  var _prefs;


  getUserData(uid, username) async {
    _prefs = await SharedPreferences.getInstance();
    await _saveUsername(username);
    await _saveUID(uid);
    await _saveFollowingList(uid);
  }

  _saveUsername(String dbUsername) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(username, dbUsername);
  }

  _saveUID(String uid) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(UID, uid);
  }

  _saveFollowingList(String uid) async {
    _prefs = await SharedPreferences.getInstance();
    String cUid = await getUID();
    var localFollowingList = await getLocalFollowingList();
    if (cUid != uid || localFollowingList == null) {
      var dbFollowingList = await _getDBFollowingList(uid);
      return await _prefs.setStringList(followingList, dbFollowingList);
    }
  }

  getLocalFollowingList()  async {
    _prefs = await SharedPreferences.getInstance();
    return  _prefs.getStringList(followingList);
  }

  getUID() async {
    _prefs = await SharedPreferences.getInstance();
    return await _prefs.getString(UID);
  }

  getUsername() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(username);
  }

  _getDBFollowingList(uid) async {
    _prefs = await SharedPreferences.getInstance();
    return await FirebaseDatabase.instance
        .reference()
        .child('Follow')
        .child(uid)
        .child('following')
        .once()
        .then((DataSnapshot snapshot) {
      List<String> list = [];

      for (var d in snapshot.value.keys) {
        list.add(d);
      }
      return list;
    });
  }
}
