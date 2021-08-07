import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/controllers/user_meme_controller.dart';
import 'package:memexd/widgets/custom_app_bar.dart';
import 'package:memexd/widgets/progress_indicator.dart';
import 'package:memexd/widgets/user_meme_list.dart';

class UserMemesScreen extends StatefulWidget {
  static String get id => 'User_Meme_Screen';

  @override
  _UserMemesScreenState createState() => _UserMemesScreenState();
}

class _UserMemesScreenState extends State<UserMemesScreen> {
  String id = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    context.read(userMemeProvider.notifier).sortPostsbyUser(id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppbar(context),
        body: Consumer(builder: (context, watch, child) {
          return watch(userMemeProvider).when(
              data: (_) =>
                  UserMemeList(posts: watch(userMemeProvider).data!.value),
              loading: () => Progress(),
              error: (e, _) => Container(
                    child: Text('error occured'),
                  ));
        }),
      ),
    );
  }
}
