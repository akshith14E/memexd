import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class CreateUser {
  String? id;
  String? userName;
  String? name;
  String? gender;
  String? dob;
  String? bio;
  String? profilePicture;

  CreateUser({
  this.userName,
  this.name,
  this.bio,
  this.profilePicture,
});

}
