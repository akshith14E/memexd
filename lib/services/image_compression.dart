
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

Future<ui.Image> compressImage(ui.Image source, int dWidth, int dHeight, int dQuality) async {

    var pngBytes = await source.toByteData(format: ui.ImageByteFormat.png);
    var result = await FlutterImageCompress.compressWithList(
      pngBytes!.buffer.asUint8List(),
      minWidth: dWidth,
      minHeight: dHeight,
      quality: dQuality,
      rotate: 0,
      format: CompressFormat.png
    );
    final image1 = await decodeImageFromList(result);
    return image1;
  }