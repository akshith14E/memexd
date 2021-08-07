import 'dart:math';
import 'dart:typed_data';
import 'package:memexd/utility/stack_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/models/widget_model.dart';
import 'dart:collection';

class WidgetData extends StateNotifier<List<WidgetModel>> {

  WidgetData() : super([]);
  List<WidgetModel> widgets = [];

  StackList S = StackList();

  void addText() {
    state = [
      ...state,
      new WidgetModel(widgetId: state.length, text: "", type: 0),
    ];
    WidgetModel temp = state[state.length - 1].copyWith();
    S.push(temp);
  }

  void addSticker(String imgPath) {
    state = [
      ...state,
      new WidgetModel(widgetId: state.length, imagePath: imgPath, type: 1, scale: 0.25 ),
    ];
    WidgetModel temp = state[state.length - 1].copyWith();
    S.push(temp);
  }

  void addStickerCustom(Uint8List? bytes) {
    state = [
      ...state,
      new WidgetModel(widgetId: state.length, bytes: bytes, type: 2 ,scale: 0.25 ),
    ];
    WidgetModel temp = state[state.length - 1].copyWith();
    S.push(temp);
  }

  void changeTextSize(int index, double newSize) {
    WidgetModel temp = state[index].copyWith();
    S.push(temp);
    state[index].size = newSize;
    state = state;
  }

  void changeColor(int index, Color newColor) {
    WidgetModel temp = state[index].copyWith();
    S.push(temp);
    state[index].color = newColor;
    state = state;
  }

  void changeFont(int index, String font) {
    WidgetModel temp = state[index].copyWith();
    S.push(temp);
    state[index].style = font;
    state = state;
  }

  void changeBackgroundColor(int index, Color newBGColor) {
    WidgetModel temp = state[index].copyWith();
    S.push(temp);
    state[index].backgroundColor = newBGColor;
    state[index].outlineColor = newBGColor;
    state[index].outlineSize = 0;
    state = state;
  }

  void changeOutlineColor(int index, Color newOutlineColor) {
    WidgetModel temp = state[index].copyWith();
    S.push(temp);
    state[index].outlineColor = newOutlineColor;
    state = state;
  }

  void changeText(int index, String newText) {
    WidgetModel temp = state[index].copyWith();
    S.push(temp);
    state[index].text = newText;
    state = state;
  }

  void changeOutlineSize(int index, double newSize) {
    double? outlineSize;
    WidgetModel temp = state[index].copyWith();
    S.push(temp);
    if (newSize == 0 || newSize == 4) {
      outlineSize = 0;
      state[index].outlineColor = Colors.transparent;
    }
    else if (newSize == 1){
      outlineSize = 0.5;
      state[index].backgroundColor = Colors.transparent;
    }
    else if (newSize == 2){
      outlineSize = 1.25;
      state[index].backgroundColor = Colors.transparent;
    }
    else if (newSize == 3){
      outlineSize = 2;
      state[index].backgroundColor = Colors.transparent;
    }

    state[index].outlineSize = outlineSize;
    state = state;
  }

  void changePosition(int index, Offset newPosition) {

    state[index].position = newPosition;
    state = state;
  }
  void savePos(int index, Offset newPosition) {
    WidgetModel temp = state[index].copyWith();
    S.push(temp);
  }

  void changeScale(int index, double newScale) {
    state[index].scale = newScale;
    state = state;
  }

  void changeRotation(int index, double newRotation) {

    state[index].rotation = newRotation;
    state = state;
  }

  void deleteWidget(int index){
    state[index].text = '';
    state[index].position = Offset.infinite;
    state = state;
  }

  void undoOperation() {
    S.redoPush(); // push the top of undo stack to redo stack
    S.isEmptyStack ? print('UNDO stack is empty') : S.pop();


    WidgetModel temp = S.top();
    state[temp.widgetId!] = S.top();
    state = state;
  }

  void redoOperation() {
    final WidgetModel redoTop = S.redoTop();
    S.push(redoTop);

    S.redoPop();

    state[redoTop.widgetId!] = redoTop;
    state = state;
  }

  void clearState(){
    state.clear();
  }
}



