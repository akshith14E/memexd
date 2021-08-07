import 'package:flutter/material.dart';
import 'package:memexd/models/fetched_user_model.dart';
import 'package:memexd/screens/searched_user_profile.dart';

class SearchMemersTile extends StatelessWidget {
  final List<FetchedUser> list;

  SearchMemersTile(this.list);

  @override
  Widget build(BuildContext context) {
    return list.length == 0
        ? Center(
            child: Text('No Users Found'),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    var id = list[index].uid;
                    return SearchedProfile(userId: id ?? "");
                  }),
                );
              },
              child: ListTile(
                tileColor: Theme.of(context).scaffoldBackgroundColor,
                contentPadding: EdgeInsets.all(10),
                leading: CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.05,
                  backgroundImage: NetworkImage(list[index].imageUrl!),
                ),
                title: Text(
                  list[index].username!,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontFamily: 'Montserrat',
                        fontSize: 17,
                      ),
                ),
              ),
            ),
            physics: BouncingScrollPhysics(),
          );
  }
}
