import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/controllers/saved_posts_controller.dart';
import 'package:memexd/controllers/user_meme_controller.dart';
import 'package:memexd/screens/profile_screen.dart';
import 'package:memexd/widgets/custom_app_bar.dart';
import 'package:memexd/widgets/progress_indicator.dart';
import 'package:memexd/widgets/saved_post_list.dart';
import 'package:memexd/widgets/user_meme_list.dart';

class SavedPostListScreen extends StatefulWidget {
  static String get id => 'Saved_Posts_Screen';

  @override
  _SavedPostListScreenState createState() => _SavedPostListScreenState();
}

class _SavedPostListScreenState extends State<SavedPostListScreen> {
  String id = "-MKUE_Im3i_8976ySjli";
  @override
  void initState() {
    super.initState();
    context.read(savedPostsProvider.notifier).sortPostsbySavedPosts(id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppbar(context),
        body: Consumer(builder: (context, watch, child) {
          return watch(savedPostsProvider).when(
              data: (_) =>
                  SavedPostList(posts: watch(savedPostsProvider).data!.value),
              loading: () => Progress(),
              error: (e, _) => Container(
                    child: Text('error occured'),
                  ));
        }),
      ),
    );
  }
}
