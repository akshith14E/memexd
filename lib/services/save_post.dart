
import 'dart:convert';

import 'package:memexd/constants/cache_constants.dart';
import 'package:memexd/constants/stringX.dart';
import 'package:memexd/models/saved_post.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


void savePostToLocal(SavedPost post) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? savedPostList = [];
  var list = prefs.getStringList(savedPostListKey);
  if(list!=null) {
    list.add(post.postId);
    savedPostList = list;
  }
  else {
    savedPostList.add(post.postId);
  }
  prefs.setStringList(savedPostListKey , savedPostList);
  prefs.setString(
    post.postId,
    json.encode(post.toMap())
  );

}