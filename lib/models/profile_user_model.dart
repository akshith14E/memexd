
import 'package:firebase_auth/firebase_auth.dart';


class ProfileUser {
  String? id = FirebaseAuth.instance.currentUser!.uid;
  String? following;
  String? name;
  String? followers;
  String? post;
  String? bio;
  String? profilePicture;

  ProfileUser({
    this.followers,
    this.name,
    this.following,
    this.post,
    this.bio,
    this.profilePicture,
  });
}