import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:memexd/controllers/post_controller.dart';
import 'package:memexd/models/post_model.dart';
import 'package:memexd/services/ad_helper.dart';
import 'package:memexd/widgets/post_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Feed extends StatefulWidget {
  final List<Post> posts;
  final bool inXplore;

  const Feed({Key? key, required this.posts, required this.inXplore})
      : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent / 1.2 &&
          !_scrollController.position.outOfRange) {
        context.read(postsProvider.notifier).query(widget.inXplore, false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(context.read(postsProvider.notifier).refreshing);
    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.all(8),
      itemCount: widget.posts.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.posts.length) {
          if (context.read(postsProvider.notifier).hasMorePosts)
            return Center(child: CircularProgressIndicator());
          else
            return SizedBox.shrink();
        } else {
          return PostWidget(
            post: widget.posts[index],
          );
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        if (index != 0 && index % 3 == 0) {
          return FittedBox(
            child: BannerAdsWidget(
              adSize: AdSize.mediumRectangle,
            ),
            fit: BoxFit.fill,
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
