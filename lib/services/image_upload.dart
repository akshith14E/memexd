import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String?> uploadImageToFirebase(File? _imageFilePath) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref =
      storage.ref().child('uploads').child('test' + DateTime.now().toString());
  TaskSnapshot taskSnapshot = await ref.putFile(_imageFilePath!);
  final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}

Future<String?> uploadImageFromUrl(String imageUrl) async {
  var rng = new Random();
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
  http.Response response = await http.get(Uri.parse(imageUrl));
  await file.writeAsBytes(response.bodyBytes);
  final String downloadUrl = (await uploadImageToFirebase(file))!;
  if (await file.exists()) {
    await file.delete();
  }
  return downloadUrl;
}
