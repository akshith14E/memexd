import 'package:memexd/constants/stringX.dart';
import 'package:memexd/models/comment_model.dart';
import 'package:memexd/models/fetched_user_model.dart';
import 'package:memexd/models/rating_model.dart';

class Post {
  PostFromDB p;
  Rating r;
  FetchedUser u;
  NoOfComments nc;

  Post({required this.p, required this.r, required this.u, required this.nc});

  Post copyWith({
    PostFromDB? p,
    Rating? r,
    FetchedUser? u,
    NoOfComments? nc,
  }) {
    return Post(
      p: p ?? this.p,
      r: r ?? this.r,
      u: u ?? this.u,
      nc: nc ?? this.nc,
    );
  }
}

class PostFromDB {
  final String postId;
  final String publisher;
  final String time;
  final String caption;
  final double tr;
  final int trtrs;
  final String postImage;
  final String tu;
  final bool g;

  const PostFromDB({
    required this.caption,
    required this.postId,
    required this.postImage,
    required this.publisher,
    required this.time,
    required this.tr,
    required this.trtrs,
    required this.tu,
    required this.g,
  });

  factory PostFromDB.fromJson(dynamic map) {
    //print(map['postId']);
    print(map['tr']);
    print(map);
    return new PostFromDB(
        postId: map['postId'].toString(),
        publisher: map['publisher'].toString(),
        time: map['time'].toString(),
        caption: map['caption'].toString(),
        tr: map['tr'].toDouble(),
        trtrs: map['trtrs'],
        postImage: stringX + map['postImage'].toString(),
        tu: map['tu'] ?? "",
        g: map['g'] ?? false);
  }

  PostFromDB copyWith({
    String? postId,
    String? publisher,
    String? time,
    String? caption,
    double? tr,
    int? trtrs,
    String? postImage,
    bool? g,
    String? tu,
  }) {
    return PostFromDB(
      postId: postId ?? this.postId,
      publisher: publisher ?? this.publisher,
      time: time ?? this.time,
      caption: caption ?? this.caption,
      tr: tr ?? this.tr,
      trtrs: trtrs ?? this.trtrs,
      postImage: postImage ?? this.postImage,
      g: g ?? this.g,
      tu: tu ?? this.tu,
    );
  }
}
