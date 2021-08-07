import 'package:flutter/material.dart';
import 'package:memexd/controllers/saved_posts_controller.dart';
import 'package:memexd/models/post_model.dart';
import 'package:memexd/services/ad_helper.dart';
import 'package:memexd/widgets/post_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedPostList extends StatefulWidget {
  final List<Post> posts;
  SavedPostList({Key? key, required this.posts}) : super(key: key);

  @override
  _SavedPostListState createState() => _SavedPostListState();
}

class _SavedPostListState extends State<SavedPostList> {
  @override
  void initState() {
    context.read(savedPostsProvider.notifier);

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
          if (context.read(savedPostsProvider.notifier).hasMorePosts)
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
