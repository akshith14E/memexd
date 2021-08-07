import 'package:flutter/material.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/controllers/comments_controller.dart';
import 'package:memexd/models/comment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/providers/auth_provider.dart';

class CommentsScreen extends StatefulWidget {
  static String get id => "./Comments_Screen";
  final String postId;

  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read(commentsProvider(widget.postId).notifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _commentAppBar(context),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Consumer(builder: (context, watch, child) {
          return watch(commentsStream(widget.postId)).when(
              data: (event) {
                final data = watch(commentsProvider(widget.postId));
                return Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) =>
                                _commentTile(context, data, index)),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(color: Theme.of(context).dividerColor,offset: Offset(0,5),blurRadius:5,spreadRadius: -5),
                                        ]
                                      ),
                                      child: TextFormField(
                                        controller: _commentFieldController,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            ?.copyWith(fontSize: 16),
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          hintText: 'Add your comment..',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(fontSize: 16),
                                          fillColor:
                                              Theme.of(context).backgroundColor,
                                          filled: true,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: IconButton(
                                  onPressed: () {
                                    context
                                        .read(commentsProvider(widget.postId)
                                            .notifier)
                                        .addData(
                                          postId: widget.postId,
                                          comment:
                                              _commentFieldController.text.trim(),
                                        );
                                    _commentFieldController.text = '';
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    size: 32,
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
              loading: () => CircularProgressIndicator(),
              error: (error, _) => Container());
        }),
      ),
    );
  }

  Widget _commentTile(BuildContext context, List<Comment> data, int index) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shadowColor: Theme.of(context).dividerColor,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 10),
        horizontalTitleGap: 0,
        leading: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.01,
              left: MediaQuery.of(context).size.height * 0.01,
              bottom: MediaQuery.of(context).size.height * 0.01),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.height * 0.09,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: data[index].u.imageUrl != ""
              ? FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: AssetImage('images/memexdlogo.png'),
                  image: NetworkImage(data[index].u.imageUrl!),
                  imageErrorBuilder: (context, error, stackTrace) => Container(
                      child: Image(
                    image: AssetImage('images/memexdlogo.png'),
                  )),
                )
              : CircleAvatar(
                  backgroundImage: AssetImage('images/profile_picture.png'),
                ),
        ),
        title: Text(
          data[index].u.username!,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontSize: MediaQuery.of(context).size.height * 0.025,color: Theme.of(context).highlightColor)
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(data[index].c.comments,
              style:
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16)),
        ),
        trailing: data[index].c.pub ==
                context.read(authServicesProvider).getCurrentUser()?.uid
            ? IconButton(
                alignment: Alignment.centerRight,
                icon: Icon(Icons.delete),
                onPressed: () {
                  context
                      .read(commentsProvider(widget.postId).notifier)
                      .deleteComment(commentId: data[index].c.cmntId);
                })
            : SizedBox(width: MediaQuery.of(context).size.width * 0.3),
      ),
    );
  }

  AppBar _commentAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        "Comments",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 26),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left_outlined,
          color: Colors.grey[400],
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
