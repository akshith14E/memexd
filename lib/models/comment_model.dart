import 'package:memexd/models/fetched_user_model.dart';

class NoOfComments {
  final String tc;

  const NoOfComments({required this.tc});

  factory NoOfComments.fromJson(dynamic map) {
    return new NoOfComments(
      tc: map['tc'] as String,
    );
  }

  NoOfComments copyWith({
    String? tc,
  }) {
    return NoOfComments(
      tc: tc ?? this.tc,
    );
  }
}

class CommentFromDB {
  final String comments;
  final String pub;
  final String cmntId;
  const CommentFromDB(
      {required this.comments, required this.pub, required this.cmntId});

  factory CommentFromDB.fromJson(dynamic map) {
    return CommentFromDB(
        comments: map['cmnt'], pub: map['pub'], cmntId: map['cmntId'] ?? "");
  }

  CommentFromDB copyWith({
    String? comments,
    String? pub,
    String? cmntId,
  }) {
    return CommentFromDB(
      comments: comments ?? this.comments,
      pub: pub ?? this.pub,
      cmntId: cmntId ?? this.cmntId,
    );
  }
}

class Comment {
  final CommentFromDB c;
  final FetchedUser u;

  Comment({required this.c, required this.u});

  Comment copyWith({
    CommentFromDB? c,
    FetchedUser? u,
  }) {
    return Comment(
      c: c ?? this.c,
      u: u ?? this.u,
    );
  }
}
