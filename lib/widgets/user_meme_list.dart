import 'package:flutter/material.dart';
import 'package:memexd/controllers/template_example_controller.dart';
import 'package:memexd/controllers/user_meme_controller.dart';
import 'package:memexd/models/post_model.dart';
import 'package:memexd/screens/profile_screen.dart';
import 'package:memexd/services/ad_helper.dart';
import 'package:memexd/widgets/post_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserMemeList extends StatefulWidget {
  final List<Post> posts;
  UserMemeList({Key? key, required this.posts}) : super(key: key);

  @override
  _UserMemeListState createState() => _UserMemeListState();
}

class _UserMemeListState extends State<UserMemeList> {
  @override
  void initState() {
    context.read(userMemeProvider.notifier);

    super.initState();
  }

  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(8),
      itemCount: widget.posts.length,
      itemBuilder: (context, index) {
        return PostWidget(
          post: widget.posts[index],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        if (index == widget.posts.length) {
          if (context.read(userMemeProvider.notifier).hasMorePosts)
            return Center(child: CircularProgressIndicator());
          else
            return SizedBox.shrink();
        }
        if (index != 0 && index % 4 == 0) {
          return Card(
            child: BannerAdsWidget(
              height: MediaQuery.of(context).size.height / 1.3,
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
