import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';

class CreateUser {
  final String? id;
  final String? username;
  final String? name = FirebaseAuth.instance.currentUser!.displayName;
  final String? gen = null;
  final String? dob = null;
  final String? bio;
  final String? imageURL;
  final int? tflng = 0;
  final int? tfrs = 0;
  final int? tpsts = 0;
  final databaseRef = FirebaseDatabase.instance.reference();
  final firebaseRef = FirebaseAuth.instance.currentUser!;

  CreateUser({this.id, this.username, required this.imageURL, this.bio});
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email','profile']);

  get http => null;

  Future<String?> getGender() async {
    final headers = await googleSignIn.currentUser!.authHeaders;
    final r = await http.get("https://people.googleapis.com/v1/people/me?personFields=genders&key=",
        headers: {
          "Authorization": headers["Authorization"]
        }
    );
    final response = jsonDecode(r.body);
    return response["genders"][0]["formattedValue"];
  }
  Future<String> getDOB() async {
    final headers = await googleSignIn.currentUser!.authHeaders;
    final r = await http.get("https://people.googleapis.com/v1/people/me?personFields=birthdays&key=",
        headers: {
          "Authorization": headers["Authorization"]
        }
    );
    final response = jsonDecode(r.body);
    return response["birthdays"][0]["formattedValue"];
  }


  Future<void> pushDetails() async {
    await databaseRef
        .child('Users')
        .child(firebaseRef.uid)
        .set({
      "username": username,
      "bio": bio,
      "name": firebaseRef.displayName,
      "id": firebaseRef.uid,
      "dob": null,
      "gen": null,
      "imageUrl": imageURL,
      //"phoneNumber": firebaseRef.phoneNumber,
      "tflng": 0,
      "tfrs": 0,
      "tpsts": 0,
    });
  }
}
