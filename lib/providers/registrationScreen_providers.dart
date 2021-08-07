import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

final usernameExistsProvider = StateProvider<bool>((ref) => false);
final isCheckedProvider = StateProvider<bool>((ref) => false);

final croppedImageProvider = StateProvider<String?>((ref) => '');

final isChangedProvider = StateProvider<bool>((ref)=>false);

// *** Providers for edit Profile screen*** //

final usernameExistsProvider1 = StateProvider<bool>((ref) => false);
final isCheckedProvider1 = StateProvider<bool>((ref) => false);

final croppedImageProvider1 = StateProvider<String?>((ref) => '');

final isChangedProvider1 = StateProvider<bool>((ref)=>false);

