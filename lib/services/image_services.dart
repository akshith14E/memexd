import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'dart:io';
import 'package:memexd/constants/text_style_constants.dart';
import 'package:memexd/constants/color_constants.dart';

final String? cropTitle = Text(
  'Crop Image',
  style: kWelcomeText,
) as String?;

Future<String?> imagePickCrop(ImageSource source) async {
  PickedFile? _imageFile = (await ImagePicker().getImage(
    source: source,
  ));
  var croppedImagePath = await imageCrop(_imageFile!.path);

  return croppedImagePath;
}

Future<String?> imageCrop(String path) async {
  File? croppedImage = await ImageCropper.cropImage(
    sourcePath: path,
    compressQuality: 80,
    //to compress the image
    maxHeight: 1100,
    maxWidth: 1100,
    cropStyle: CropStyle.rectangle,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
    ],
    androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: kSignInButtonColor2,
        activeControlsWidgetColor: kSignInButtonColor2,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: true),
  );
  return croppedImage!.path;
}

// Method to crop images in dynmaic ratio
Future<String?> imagePickCropDynamic(ImageSource source) async {
  PickedFile? _imageFile = (await ImagePicker().getImage(
    source: source,
  ));
  var croppedImagePath = await imageCropDynamic(_imageFile!.path);

  return croppedImagePath;
}

Future<String?> imageCropDynamic(String path) async {
  File? croppedImage = await ImageCropper.cropImage(
    sourcePath: path,
    compressQuality: 80,
    //to compress the image
    maxHeight: 1100,
    maxWidth: 1100,
    cropStyle: CropStyle.rectangle,
    aspectRatioPresets: Platform.isAndroid
        ? [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.original,
          ]
        : [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio16x9
          ],
    androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: kSignInButtonColor2,
        activeControlsWidgetColor: kSignInButtonColor2,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: true),
  );
  return croppedImage!.path;
}
