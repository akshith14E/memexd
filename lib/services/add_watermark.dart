import 'dart:ffi';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memexd/services/image_compression.dart';

Future<ui.Image> addWatermark(ui.Image source, String username) async {

    Canvas canvas;
    Paint paint;
    double ratio = 0.045;
    Rect rImage;
    ui.PictureRecorder recorder = ui.PictureRecorder();
    double width, height;
    double scale;
    width = source.width.toDouble();
    height = source.height.toDouble();

    rImage = Rect.fromLTWH(0, 0, width, height + height / 20);
    paint = Paint()
        ..color = Colors.white
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4.0;

    canvas = Canvas(recorder , rImage);
    canvas.drawColor(Colors.black , BlendMode.color);
    canvas.drawImage(source, Offset.zero , paint );

    final data1 = await rootBundle.load('images/memexdlogo.png');
    final bytes1 = data1.buffer.asUint8List();
    var watermark = await decodeImageFromList(bytes1);

    scale = ((height * ratio) / watermark.height);

    watermark = await compressImage(watermark, (watermark.width*scale).toInt(), (watermark.height*scale).toInt(), 80);
    canvas.drawImage(watermark, ui.Offset(width/40, height + height/350), paint);

    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: height/36,
        fontFamily: 'Montserrat',
        letterSpacing: 2.0
    );
    final textSpan = TextSpan(
      text: 'MEMEXD',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: width,
    );
    final xCenter = width / 32 + watermark.width;
    final yCenter = height + (height / 120) ;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);


    final textStyleUserName = TextStyle(
        color: Colors.white,
        fontSize: height/36,
        fontFamily: 'Montserrat',
    );
    final textSpanUserName = TextSpan(
        text: username + '@',
        style: textStyleUserName,
    );
    final textPainterUserName = TextPainter(
      text: textSpanUserName,
      textAlign: TextAlign.end,
      textDirection: TextDirection.rtl,
    );
    textPainterUserName.layout(
        minWidth: 0,
        maxWidth: width,
    );
    final xCenterUserName = width - width / 30 - textPainterUserName.width;
    final yCenterUserName = height + (height / 120);
    final offsetUserName = Offset(xCenterUserName, yCenterUserName);
    textPainterUserName.paint(canvas, offsetUserName);

    ui.Picture picture = recorder.endRecording();
    ui.Image imageEx = await picture.toImage(width.toInt(), height.toInt() + height~/20);
    final compressedImage = await compressImage(imageEx, 700, 700, 60);

    return compressedImage;


}