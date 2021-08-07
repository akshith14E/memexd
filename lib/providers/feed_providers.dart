import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/models/widget_data.dart';
import 'package:memexd/models/widget_model.dart';
import 'package:memexd/screens/editor_screen.dart';

final showCommentWidgetProvider = StateProvider<bool>((ref) => false);

final postIdProvider = StateProvider<String>((ref) => '');

