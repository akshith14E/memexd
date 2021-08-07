import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/controllers/post_controller.dart';
import 'package:memexd/providers/feed_providers.dart';
import 'package:memexd/screens/comments_screen.dart';
import 'package:memexd/screens/profile_screen.dart';
import 'package:memexd/screens/template_screen.dart';
import 'package:memexd/services/network_checker.dart';
import 'package:memexd/widgets/app_drawer.dart';
import 'package:memexd/widgets/feed_list.dart';
import 'package:memexd/widgets/network_error_screen.dart';
import 'package:memexd/widgets/progress_indicator.dart';

class Home extends StatefulWidget {
  int? selectedScreen;

  Home({this.selectedScreen = 1});

  static const String id = 'HomePage';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late PageController _controller;
  var selectedPage;
  var connectionResult;
  StreamSubscription? subscription;
  InternetConnectionStatus networkStatus = InternetConnectionStatus.connected;

  @override
  void initState() {
    _controller = PageController(initialPage: widget.selectedScreen!);
    context.read(postsProvider.notifier).query(true, false);
    subscription = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      networkStatus = status;
      print(status.toString());
      setState(() {});
    });
    selectedPage = widget.selectedScreen;
    super.initState();
  }

  DateTime? currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    return networkStatus == InternetConnectionStatus.connected
        ? WillPopScope(
            onWillPop: () async {
              if (selectedPage == 2) {
                _controller.animateToPage(
                  1,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInCubic,
                );
              } else if (selectedPage == 0) {
                _controller.animateToPage(
                  1,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInCubic,
                );
              } else {
                DateTime now = DateTime.now();
                if (currentBackPressTime == null ||
                    now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
                  currentBackPressTime = now;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text('Back again to leave and come back soon'),
                    ),
                  );
                  return Future.value(false);
                }
                return Future.value(true);
              }
              return false;
            },
            child: Scaffold(
              drawer: AppDrawer(),
              body: Stack(
                children: [
                  PageView(
                    controller: _controller,
                    onPageChanged: (page) {
                      setState(() {
                        selectedPage = page;
                      });
                    },
                    children: [
                      ProfileScreen(),
                      _Feed(),
                      TemplateScreen(),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).backgroundColor,
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 0.75),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.height * 0.018,
                        MediaQuery.of(context).size.height * 0.912,
                        MediaQuery.of(context).size.height * 0.018,
                        MediaQuery.of(context).size.height * 0.025),
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.016,
                        MediaQuery.of(context).size.height * 0.016,
                        MediaQuery.of(context).size.width * 0.016,
                        MediaQuery.of(context).size.height * 0.016),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            child: Image.asset(
                              'images/user.png',
                              color: selectedPage == 0
                                  ? kBottomNavigationBar
                                  : Color(0xFFC4C4C4),
                            ),
                            onTap: () {
                              _controller.jumpToPage(0);
                              setState(
                                () {
                                  selectedPage = 0;
                                },
                              );
                            },
                          ),
                          GestureDetector(
                            child: Image.asset('images/home_icon.png',
                                color: selectedPage == 1
                                    ? kBottomNavigationBar
                                    : Color(0xFFC4C4C4)),
                            onTap: () {
                              _controller.jumpToPage(1);
                              setState(
                                () {
                                  selectedPage = 1;
                                },
                              );
                            },
                          ),
                          GestureDetector(
                            child: Image.asset(
                              'images/grid.png',
                              color: selectedPage == 2
                                  ? kBottomNavigationBar
                                  : Color(0xFFC4C4C4),
                            ),
                            onTap: () {
                              _controller.jumpToPage(2);
                              setState(
                                () {
                                  selectedPage = 2;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : NetworkErrorScreen();
  }
}

class _Feed extends StatefulWidget {
  const _Feed({
    Key? key,
  }) : super(key: key);

  @override
  __FeedState createState() => __FeedState();
}

class __FeedState extends State<_Feed> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.04,
                  width: MediaQuery.of(context).size.width * 0.08,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('images/memexdlogo.png'),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Center(
                  child: Text(
                    'MEMEXD',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[300],
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                      letterSpacing: 4,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                ),
              ],
            ),
          ),
          bottom: ColoredTabBar(
            color: Theme.of(context).scaffoldBackgroundColor,
            tabBar: TabBar(
              onTap: (index) {
                context.read(postsProvider.notifier).currentFeed =
                    index == 1 ? CurrentFeed.dyn : CurrentFeed.xplore;
                final state = index == 1
                    ? context.read(postsProvider.notifier).dynamicFeedPost
                    : context.read(postsProvider.notifier).xploreFeedPost;
                context.read(postsProvider.notifier).setState(state);
              },
              labelColor: Theme.of(context).textTheme.bodyText2!.color,
              indicatorColor: Theme.of(context).textTheme.bodyText2!.color,
              tabs: [
                Tab(icon: Text("Xplore", style: TextStyle(fontSize: 18))),
                Tab(icon: Text("Memexd", style: TextStyle(fontSize: 18))),
              ],
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [_FeddWithRefresh(w: _XploreFeed()), _DynamicFeed()],
        ),
      ),
    );
  }
}

//XploreFeed

class _XploreFeed extends StatefulWidget {
  _XploreFeed({Key? key}) : super(key: key);

  @override
  __XploreFeedState createState() => __XploreFeedState();
}

class __XploreFeedState extends State<_XploreFeed> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer(
        builder: (context, watch, child) {
          return watch(postsProvider).when(
            data: (_) => Feed(
              posts: watch(postsProvider).data!.value,
              inXplore: true,
            ),
            loading: () => Progress(),
            error: (e, _) => Container(
              child: Text('error occured'),
            ),
          );
        },
      ),
    );
  }
}

class _DynamicFeed extends StatefulWidget {
  _DynamicFeed({Key? key}) : super(key: key);

  @override
  __DynamicFeedState createState() => __DynamicFeedState();
}

class __DynamicFeedState extends State<_DynamicFeed> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read(postsProvider.notifier).query(false, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer(
        builder: (context, watch, child) {
          return watch(postsProvider).when(
            data: (_) => Feed(
              posts: watch(postsProvider).data!.value,
              inXplore: false,
            ),
            loading: () => Progress(),
            error: (e, _) => Container(
              child: Text('error occured'),
            ),
          );
        },
      ),
    );
  }
}

class ColoredTabBar extends ColoredBox implements PreferredSizeWidget {
  ColoredTabBar({required this.color, required this.tabBar})
      : super(color: color, child: tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;
}

class _FeddWithRefresh extends StatefulWidget {
  final Widget w;

  _FeddWithRefresh({
    Key? key,
    required this.w,
  }) : super(key: key);

  @override
  __FeddWithRefreshState createState() => __FeddWithRefreshState();
}

class __FeddWithRefreshState extends State<_FeddWithRefresh> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read(postsProvider.notifier).query(true, true);
        },
        child: widget.w,
      ),
    );
  }
}
