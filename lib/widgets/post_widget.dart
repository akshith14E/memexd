import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/constants/stringX.dart';
import 'package:memexd/controllers/post_controller.dart';
import 'package:memexd/models/post_model.dart';
import 'package:memexd/models/saved_post.dart';
import 'package:memexd/providers/auth_provider.dart';
import 'package:memexd/providers/editor_providers.dart';
import 'package:memexd/providers/feed_providers.dart';
import 'package:memexd/screens/comments_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/screens/editor_screen.dart';
import 'package:memexd/extensions/reatimeDBExtention.dart';
import 'package:memexd/screens/profile_screen.dart';
import 'package:memexd/screens/searched_user_profile.dart';
import 'package:memexd/services/ad_helper.dart';
import 'package:memexd/services/save_post.dart';
import 'package:memexd/widgets/fading_cube.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  InterstitialAdsWidget adObject = new InterstitialAdsWidget();
  double sliderValue = 0;
  int currentUsers = 0;
  String catExpression = "lowest.png";

  GlobalKey cKey = new GlobalKey();
  GlobalKey pKey = new GlobalKey();

  void changeExpression(double value) {
    if (value >= 0.0 && value < 0.2) {
      setState(() {
        catExpression = "lowest.png";
      });
    } else if (value >= 0.2 && value < 0.4) {
      setState(() {
        catExpression = "low.png";
      });
    } else if (value >= 0.4 && value < 0.6) {
      setState(() {
        catExpression = "normal.png";
      });
    } else if (value >= 0.6 && value < 0.8) {
      setState(() {
        catExpression = "high.png";
      });
    } else if (value >= 0.8 && value <= 1.0) {
      setState(() {
        catExpression = "highest.png";
      });
    }
  }

  void findAvgRating() async {
    double totalRating = widget.post.p.tr;
    int users = widget.post.p.trtrs;
    setState(() {
      currentUsers = users.toInt();
    });
    changeExpression(totalRating / users);
  }

  @override
  void initState() {
    findAvgRating();
    sliderValue = double.parse(widget.post.r.rating);
    super.initState();
  }

  Rect _getWidgetGlobalRect(GlobalKey key) {
    var renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
        offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  _options() {
    String currentUser =
        context.read(authServicesProvider).getCurrentUser()!.uid;
    showMenu(
      position: RelativeRect.fromRect(
          _getWidgetGlobalRect(pKey), _getWidgetGlobalRect(cKey)),
      context: context,
      items: [
        PopupMenuItem(
          child: widget.post.p.tu != ""
              ? TextButton(
                  onPressed: _editor,
                  child: Text("Editor",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 18)))
              : const SizedBox.shrink(),
        ),
        PopupMenuItem(
          child: widget.post.p.tu != ""
              ? TextButton(
                  onPressed: _exampleTemplates,
                  child: Text("Template examples",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 18)))
              : const SizedBox.shrink(),
        ),
        PopupMenuItem(
          child: TextButton(
              onPressed: () {
                _onShare(context);
              },
              child: Text("Share",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontSize: 18))),
          // widget.post.p.publisher ==
          //         context.read(authServicesProvider).getCurrentUser()!.uid
          //     ?
        ),
        PopupMenuItem(
            child: TextButton(
          onPressed: () async {
            Navigator.pop(context);
            String id = widget.post.p.postId;
            var posts = context.read(postsProvider.notifier).getPosts;
            print(posts!.length);
            var filteredPosts = posts.where((e) => e.p.postId != id).toList();
            context.read(postsProvider.notifier).setState(filteredPosts);
            await context
                .read(firebaseDBProvider)
                .byChild("Posts")
                .child(id)
                .remove();
          },
          child: widget.post.p.publisher == currentUser
              ? Text("Delete",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontSize: 18))
              : const SizedBox.shrink(),
        ))
      ],
    );
  }

  _exampleTemplates() {}

  _editor() {
    context.read(customTemplateProvider).state = null;
    context.read(templateImageProvider).state = CachedNetworkImage(
      imageUrl: stringX + widget.post.p.tu,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
    adObject.showInterad();
    Navigator.pushNamed(context, EditorScreen.id);
  }

  void _onShare(BuildContext context) async {
    var postImage = await get(Uri.parse(widget.post.p.postImage));
    var userImage = await get(Uri.parse(widget.post.u.imageUrl!));

    savePostToLocal(savedPostFromPostData(widget.post.p, widget.post.u,
        base64Encode(postImage.bodyBytes), base64Encode(userImage.bodyBytes)));
    final box = context.findRenderObject() as RenderBox?;
    var response = await get(Uri.parse(widget.post.p.postImage));
    try {
      final documentDirectory =
          (await getExternalStorageDirectory().then((value) {
        return value;
      }))
              ?.path;
      File imgFile = new File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);

      await Share.shareFiles(['$documentDirectory/flutter.png'],
          text: widget.post.p.caption +
              '\nBy via MemexD\nFrom hera pheri, to marvel,create, browse and share thousands of meme templates from around the world.\nDownload the app, now!\n' +
              'https://play.google.com/store/apps/details?id=com.pi14.memexd',
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var date = DateFormat.yMMMMd().format(DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.post.p.time).abs()));

    var time =
        DateTime.fromMillisecondsSinceEpoch(int.parse(widget.post.p.time).abs())
            .toString()
            .split(" ")[1]
            .split(":");
    String timeString = time[0] + ":" + time[1];
    print(timeString);
    return Container(
      key: cKey,
      height: MediaQuery.of(context).size.height / 1.3,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 2,
                color: Theme.of(context).backgroundColor),
            BoxShadow(
                offset: Offset(0, -2),
                blurRadius: 2,
                color: Theme.of(context).backgroundColor),
          ],
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        // margin: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                margin: EdgeInsets.all(2),
                                child: widget.post.u.imageUrl != ""
                                    ? FadeInImage(
                                        fit: BoxFit.cover,
                                        placeholder: AssetImage(
                                            'images/profile_picture.png'),
                                        image: NetworkImage(
                                            widget.post.u.imageUrl!),
                                        imageErrorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          child: Image(
                                            image: AssetImage(
                                                'images/profile_picture.png'),
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'images/profile_picture.png'),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    child: Text(
                                      widget.post.u.username!,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(fontSize: 20),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SearchedProfile(
                                              userId: widget.post.p.publisher),
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    timeString +
                                        ", " +
                                        date.toString().split("-")[0],
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                        GestureDetector(
                          key: pKey,
                          onTap: () {
                            _options();
                          },
                          child: Icon(
                            Icons.more_vert,
                            size: MediaQuery.of(context).size.width / 13,
                          ),
                        )
                      ],
                    ),
                  ),
                  widget.post.p.caption == ""
                      ? SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: Text(
                            widget.post.p.caption,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontSize: 18),
                          ),
                        ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onLongPress: () {
                        _onShare(context);
                      },
                      onDoubleTap: () {
                        if (sliderValue != 1) {
                          setState(() {
                            sliderValue = 1;
                          });

                          var value = (sliderValue);
                          context
                              .read(postsProvider.notifier)
                              .updateRating(widget.post, value / 5);
                          print(value);
                        }
                        findAvgRating();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Image.network(
                          widget.post.p.postImage,
                          loadingBuilder: (context, a, b) {
                            if (b == null) return a;
                            return SpinKitFadingCube(
                              color: kPrimaryColor,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.message,
                              size: 32,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(CommentsScreen.id,
                                  arguments: widget.post.p.postId);
                            },
                          ),
                          Text(widget.post.nc.tc)
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context),
                        child: Slider(
                          value: sliderValue,
                          onChanged: (d) {
                            setState(() {
                              sliderValue = d;
                            });
                            var value = (d * 5.round());
                            context
                                .read(postsProvider.notifier)
                                .updateRating(widget.post, value / 5);
                            setState(() {
                              findAvgRating();
                            });
                          },
                        ),
                      ),
                      Column(
                        children: [
                          Image.asset(
                            "images/" + catExpression,
                            height: 33,
                            width: 35,
                          ),
                          Text(currentUsers.toString()),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
