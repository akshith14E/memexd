import 'dart:collection';
import 'package:flutter/material.dart';

class StackList<WidgetModel> {
  var _stack;
  var _redoStack;

  StackList() {
    this._stack = Queue<WidgetModel>();
    this._redoStack = Queue<WidgetModel>();
  }
  void push(WidgetModel element) {
    _stack.addLast(element);
  }

  WidgetModel pop() {
    final WidgetModel lastElement = _stack.last;
    _stack.removeLast();
    return lastElement;
  }

  WidgetModel top() {
    return _stack.last;
  }

  void clear() {
    _stack.clear();
  }

  bool get isEmptyStack => _stack.isEmpty;

  // *** methods for redo stack ***//

  void redoPush() {
    _redoStack.add(top());
  }

  WidgetModel redoPop() {
    final WidgetModel lastElement = _redoStack.last;
    _redoStack.removeLast();
    return lastElement;
  }

  WidgetModel redoTop() {
    return _redoStack.last;
  }

  bool get isEmptyRedo => _redoStack.isEmpty;
}
