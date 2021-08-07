import 'dart:typed_data';

import 'package:flutter/material.dart';

class WidgetModel {
  String? text;
  Color? color;
  int? widgetId;
  double? size;

  String? style;
  Color? backgroundColor;
  Color? outlineColor;
  double? outlineSize;
  int? type;

  Offset? position;
  double? scale;
  double? rotation;
  String? imagePath;
  Uint8List? bytes;
  static const Offset offset = Offset(0.05,0.05);

  WidgetModel(
      {this.text,
      this.color = Colors.black,
      this.widgetId,
      this.size = 25,
        this.style = 'Montserrat',
      this.backgroundColor = Colors.transparent,
      this.outlineColor = Colors.transparent,
      this.outlineSize = 0,
      this.type,
      this.position = offset,
      this.scale = 1,
      this.rotation = 0.0,
      this.imagePath,
        this.bytes
      });

  WidgetModel copyWith({
  String? text, Color? color, int? widgetId, double? size, Color? backgroundColor, Color? outlineColor, double? outlineSize, int? type,
  Offset? position, double? scale, double? rotation, String? imagePath, String? style, Uint8List? bytes
  }) => WidgetModel(
    text: text ?? this.text,
    color: color ?? this.color,
    widgetId: widgetId ?? this.widgetId,
    size: size ?? this.size,
    style: style ?? this.style,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    outlineColor: outlineColor ?? this.outlineColor,
    outlineSize: outlineSize ?? this.outlineSize,
    type: type ?? this.type,
    position: position ?? this.position,
    scale: scale ?? this.scale,
    rotation: rotation ?? this.rotation,
    imagePath: imagePath ?? this.imagePath,
    bytes: bytes ?? this.bytes
  );
}
