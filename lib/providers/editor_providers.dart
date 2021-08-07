import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/models/widget_data.dart';
import 'package:memexd/models/widget_model.dart';
import 'package:memexd/screens/editor_screen.dart';

final showTextWidgetProvider = StateProvider<bool>((ref) => false); //{}
final showStickerWidgetProvider = StateProvider<bool>((ref) => false);
final showDeleteWidgetProvider = StateProvider<bool>((ref) => false);

final selectedWidgetMarker1Provider =
StateProvider<WidgetMarker1>((ref) => WidgetMarker1.none);

final widgetDataProvider = StateNotifierProvider<
    WidgetData , List<WidgetModel>>(
        (ref) => WidgetData());

final selectedWidgetIndexProvider = StateProvider<int?>((ref) => -1);
final selectedWidgetProvider = StateProvider<int?>((ref) => -1);

final workspaceBorderColorProvider = StateProvider<Color?>((ref) => Colors.black54);

// *** add_text_widget.dart providers ***

final pickedColorProvider = StateProvider<Color?>((ref) => Colors.black);
final pickedOutlineColorProvider = StateProvider<Color?>((ref) => Colors.transparent);
final pickedBackgroundColorProvider = StateProvider<Color?>((ref) => Colors.transparent);
final pickedFontProvider = StateProvider<String?>((ref) => 'Montserrat');

final outlineSizeSliderProvider = StateProvider<double?>((ref) => 0);
final textSizeSliderProvider = StateProvider<double?>((ref) => 25);

// *** add_stickers.dart providers *** //

final pickedStickerProvider = StateProvider<String?>((ref) => null);

// *** cutout.dart providers *** //

final pickedStickerImageProvider = StateProvider<String?>((ref) => null);
final cutoutImageProvider = StateProvider<Uint8List?>((ref) => null);      // TODO initialise it with image picked from phone

// *** template screen to editor provider ///

final templateImageProvider = StateProvider<Widget?>((ref) => null);
final customTemplateProvider = StateProvider<String?>((ref) => null);