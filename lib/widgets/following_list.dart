import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/controllers/follow_controller.dart';
import 'package:memexd/models/fetched_user_model.dart';
import 'package:memexd/models/user_model.dart';
import 'package:memexd/screens/profile_screen.dart';
import 'package:memexd/services/get_user_data.dart';
import 'package:memexd/widgets/following_tile.dart';

class FollowingList extends StatefulWidget {
  final String? sorter;

  FollowingList({this.sorter});
  @override
  _FollowingListState createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      context.read(followProvider.notifier).initFollowing();
      context.read(followProvider.notifier).initFollowers();
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    // if (widget.sorter == 'following') {
    //   context.read(followProvider.notifier).getFollowing();
    // } else if (widget.sorter == 'followers') {
    //   context.read(followProvider.notifier).getFollowers();
    // }
    print("here mother fucker");
    return Consumer(
      builder: (context, watch, child) {
        return watch(followProvider).when(
          data: (list) {
            return list == []
                ? Center(
                    child: Text('Please search for a movie or try again'),
                  )
                : FollowingTile(list);
          },
          loading: () {
            return CircularProgressIndicator();
          },
          error: (
            error,
            r,
          ) =>
              AlertDialog(
            content: Text('Something went wrong'),
            actions: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Ok')),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
