import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memexd/models/fetched_user_model.dart';
import 'package:memexd/models/user_model.dart';
import 'package:memexd/screens/profile_screen.dart';

class FollowingTile extends StatefulWidget {
  final List<FetchedUser> list;
  FollowingTile(this.list);
  @override
  _FollowingTileState createState() => _FollowingTileState();
}

class _FollowingTileState extends State<FollowingTile> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.list.length,
      //itemCount: 3,

      itemBuilder: (context, index) {
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            ListTile(
              tileColor: Colors.white,
              contentPadding: EdgeInsets.all(10),
              leading: CircleAvatar(
                backgroundImage: AssetImage('images/memexdlogo.png'),
                radius: MediaQuery.of(context).size.height * 0.05,
                foregroundImage: NetworkImage(
                  widget.list[index].imageUrl!,
                  //'images/memexdlogo.png'
                ),
              ),
              title: Text(
                //'Hello',
                widget.list[index].username!,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
              trailing: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: FlatButton(
                  onPressed: () {},
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Unfollow',
                    style: TextStyle(
                      color: Theme.of(context).backgroundColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
