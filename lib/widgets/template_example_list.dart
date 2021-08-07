import 'package:flutter/material.dart';
import 'package:memexd/controllers/post_controller.dart';
import 'package:memexd/controllers/template_example_controller.dart';
import 'package:memexd/models/post_model.dart';
import 'package:memexd/screens/profile_screen.dart';
import 'package:memexd/services/ad_helper.dart';
import 'package:memexd/widgets/post_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemplateExampleList extends StatefulWidget {
  final List<Post> posts;
  TemplateExampleList({Key? key, required this.posts}) : super(key: key);

  @override
  _TemplateExampleListState createState() => _TemplateExampleListState();
}

class _TemplateExampleListState extends State<TemplateExampleList> {
  String url =
      "templates%2F1603524675404.null?alt=media&token=2292a884-4c4a-418f-b9b8-4f24d0dd06bb";
  @override
  void initState() {
    context.read(templateExampleProvider.notifier).sortPostsbyTemplates(url);

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
          if (context.read(templateExampleProvider.notifier).hasMorePosts)
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
