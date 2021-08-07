import 'package:memexd/models/post_model.dart';
import 'package:memexd/models/rating_model.dart';

import 'comment_model.dart';
import 'fetched_user_model.dart';

class SavedPost {
  String postId;
  String publisher;
  String time;
  String caption;
  double totalRatings;
  int totalRaters;
  String postImage;
  String tu;
  String username;
  String userImage;

  SavedPost({required this.postId, required this.publisher, required this.time, required this.caption,
        required this.totalRatings, required this.totalRaters,
        required this.postImage, required this.tu,
        required this.username, required this.userImage});

  factory SavedPost.fromJson(dynamic json) => SavedPost(
    postId: json['postId'],
    publisher: json['publisher'],
    time: json['time'],
    caption: json['caption'],
    totalRatings: json['totalRatings'],
    username: json['username'],
    totalRaters: json['totalRaters'],
    tu: json['tu'],
    userImage: json['userImageUrl'],
    postImage: json['postImage'],
  );

  Map<String,dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["postId"] = postId;
    map["publisher"] = publisher;
    map["time"] = time;
    map["caption"] = caption;
    map["totalRatings"] = totalRatings;
    map["totalRaters"] = totalRaters;
    map["postImage"] = postImage;
    map["tu"] = tu;
    map["username"] = username;
    map["userImageUrl"] = userImage;

    return map;
  }


}

savedPostFromPostData(PostFromDB p, FetchedUser u, String postImage , String userImage) {
  return SavedPost(postId: p.postId, publisher: p.publisher, time: p.time, caption: p.caption,
      totalRatings: p.tr, totalRaters: p.trtrs, postImage: postImage,
      tu: p.tu, username: u.username!, userImage: userImage);
}

