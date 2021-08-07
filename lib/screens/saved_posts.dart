import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memexd/constants/cache_constants.dart';
import 'package:memexd/models/post_model.dart';
import 'package:memexd/models/saved_post.dart';
import 'package:memexd/screens/saved_posts_list_screen.dart';
import 'package:memexd/screens/user_meme_screen.dart';
import 'package:memexd/widgets/progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> savedPosts = [];

class SavedPosts extends StatefulWidget {
  static const id = 'Demo';
  const SavedPosts({Key? key}) : super(key: key);

  @override
  _SavedPostsState createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {
  @override
  void initState() {
    getSavedPostList();
    super.initState();
  }

  getSavedPostList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList(savedPostListKey);
    setState(() {
      if (list != null) savedPosts = list;
    });
  }

  getValue(String postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString(postId));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.height * 0.0243,
            right: MediaQuery.of(context).size.height * 0.0243),
        itemCount: savedPosts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder(
              future: getValue(savedPosts[index]),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    var post = SavedPost.fromJson(json.decode(snapshot.data));
                    return Material(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                      elevation: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              SavedPostListScreen.id,
                            );
                          },
                          child: Image.memory(
                            base64Decode(
                              post.postImage,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    print('Error : $snapshot.hasError');
                    return Progress();
                  } else
                    return Progress();
                } else
                  return Progress();
              });
        },
      ),
    );
  }
}
