import 'package:memexd/constants/stringX.dart';

class FetchedUser {
  final String? username;
  final String? imageUrl;
  final String? uid;
  FetchedUser({this.imageUrl, this.username, this.uid});

  factory FetchedUser.fromJson(dynamic json) {
    print(json);
    return FetchedUser(
        username: json['username'],
        uid: json['id'] ?? "",
        imageUrl: json['imageUrl'] == null ? "" : stringX + json['imageUrl']);
  }

  FetchedUser copyWith({
    String? username,
    String? imageUrl,
    String? uid,
  }) {
    return FetchedUser(
      username: username ?? this.username,
      imageUrl: imageUrl ?? this.imageUrl,
      uid: uid ?? this.uid,
    );
  }
}
