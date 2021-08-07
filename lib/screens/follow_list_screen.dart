import 'package:flutter/material.dart';
import 'package:memexd/controllers/follow_controller.dart';
import 'package:memexd/controllers/post_controller.dart';
import 'package:memexd/widgets/custom_app_bar.dart';
import 'package:memexd/widgets/following_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowListScreen extends StatefulWidget {
  static const String id = 'FollowListScreen';
  @override
  _FollowListScreenState createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  // @override
  // void initState() {
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: customAppbar(context),
        body: Column(
          children: [
            Container(
              color: Theme.of(context).textTheme.bodyText1!.color,
              child: TabBar(
                onTap: (index) {
                  var list = index == 1
                      ? context.read(followProvider.notifier).followingList
                      : context.read(followProvider.notifier).followerList;
                  context.read(followProvider.notifier).setState(list);
                },
                // controller: _tabController,
                indicatorColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                unselectedLabelColor: Theme.of(context).backgroundColor,
                labelColor: Theme.of(context).backgroundColor,
                labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(
                    text: 'Following',
                  ),
                  Tab(
                    text: 'Followers',
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8256,
              child: TabBarView(
                // controller: _tabController,
                children: [
                  FollowingList(sorter: 'following'),
                  FollowingList(sorter: 'followers'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
