import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'dart:io';


final databaseRef = FirebaseDatabase.instance.reference();
Future<bool> checkUser(String value) async{
  var user = await databaseRef
      .child("Users")
      .orderByChild("username")
      .equalTo(value)
      .once()
      .then(
          (data) => data.value);
  if (user != null)
    return true;
  else
    return false;
}