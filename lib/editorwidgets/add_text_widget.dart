import 'package:fast_color_picker/fast_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/constants/text_style_constants.dart';
import 'package:memexd/models/widget_data.dart';
import 'package:memexd/providers/editor_providers.dart';
import 'package:memexd/utility/stack_list.dart';

enum MarkerWidget { text, style, outline }

var textSize = 50.0;
var outlineWidth = 0.0;
MarkerWidget selectedWidget = MarkerWidget.text;

class AddTextWidget extends StatefulWidget {
  @override
  _AddTextWidgetState createState() => _AddTextWidgetState();
}

class _AddTextWidgetState extends State<AddTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(35), topLeft: Radius.circular(35)),
        // boxShadow: [
        //   BoxShadow(
        //       color: Colors.white10,
        //       offset: Offset(10, -10),
        //       blurRadius: 15.0,
        //       spreadRadius: 0.5)
        // ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedWidget = MarkerWidget.text;
                  });
                },
                child: Text(
                  'Text',
                  style: TextStyle(
                    color: kSignInButtonColor2,
                    fontWeight: selectedWidget == MarkerWidget.text
                        ? FontWeight.w900
                        : FontWeight.normal,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedWidget = MarkerWidget.style;
                  });
                },
                child: Text(
                  'Style',
                  style: TextStyle(
                    color: kSignInButtonColor2,
                    fontWeight: selectedWidget == MarkerWidget.style
                        ? FontWeight.w900
                        : FontWeight.normal,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedWidget = MarkerWidget.outline;
                  });
                },
                child: Text(
                  'Outline',
                  style: TextStyle(
                    color: kSignInButtonColor2,
                    fontWeight: selectedWidget == MarkerWidget.outline
                        ? FontWeight.w900
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          getCustomWidget(),
        ],
      ),
    );
  }

  Widget getCustomWidget() {
    switch (selectedWidget) {
      case MarkerWidget.text:
        return TextInput();
      case MarkerWidget.style:
        return StyleWidget();
      case MarkerWidget.outline:
        return OutlineWidget();
      default:
        return Container();
    }
  }
}

class TextInput extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _currentIndex = watch(selectedWidgetIndexProvider);
    final _initialTextValue = watch(widgetDataProvider);
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
      height: MediaQuery.of(context).size.height * 0.1,
      child: TextFormField(
        autofocus: false,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        initialValue: _initialTextValue[_currentIndex.state!].text,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
        ),
        onChanged: (value) {
          context
              .read(widgetDataProvider.notifier)
              .changeText(_currentIndex.state!, value);
        },
        decoration: InputDecoration(
          hintText: 'Type your Text here',
          focusColor: Colors.black,
          hoverColor: Colors.black,
        ),
      ),
    );
  }
}

class StyleWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _currentIndex = watch(selectedWidgetIndexProvider);
    final _pickedColor = watch(pickedColorProvider);
    final _textSizeSlider = watch(textSizeSliderProvider);
    final _pickedFont = watch(pickedFontProvider);
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
      height: MediaQuery.of(context).size.height * 0.26,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //change text size slider
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Text Size',
                style: TextStyle(color: kSignInButtonColor2),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Slider(
                  activeColor: kPrimaryColor,
                  value: _textSizeSlider.state!,
                  onChanged: (size) {

                  },
                  onChangeEnd: (size) {
                    context.read(textSizeSliderProvider).state = size;
                    context
                        .read(widgetDataProvider.notifier)
                        .changeTextSize(_currentIndex.state!, size);
                  },
                  min: 5,
                  max: 75,
                  divisions: 7,
                ),
              )
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //fetching fonts here
                TextButton(
                  onPressed: () {
                    context.read(pickedFontProvider).state = 'Montserrat';
                    context
                        .read(widgetDataProvider.notifier)
                        .changeFont(_currentIndex.state!, 'Montserrat');
                  },
                  child: Text(
                    'Montserrat',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color:
                          context.read(pickedFontProvider).state == 'Montserrat'
                              ? kSignInButtonColor2
                              : Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    context.read(pickedFontProvider).state = 'Boston';
                    context
                        .read(widgetDataProvider.notifier)
                        .changeFont(_currentIndex.state!, 'Boston');
                  },
                  child: Text(
                    'Boston',
                    style: TextStyle(
                      fontFamily: 'Boston',
                      fontWeight: FontWeight.bold,
                      color: context.read(pickedFontProvider).state == 'Boston'
                          ? kSignInButtonColor2
                          : Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    context.read(pickedFontProvider).state = 'Acme';
                    context
                        .read(widgetDataProvider.notifier)
                        .changeFont(_currentIndex.state!, 'Acme');
                  },
                  child: Text(
                    'Acme',
                    style: TextStyle(
                      fontFamily: 'Acme',
                      fontWeight: FontWeight.bold,
                      color: context.read(pickedFontProvider).state == 'Acme'
                          ? kSignInButtonColor2
                          : Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    context.read(pickedFontProvider).state = 'Benne';
                    context
                        .read(widgetDataProvider.notifier)
                        .changeFont(_currentIndex.state!, 'Benne');
                  },
                  child: Text(
                    'Benne',
                    style: TextStyle(
                      fontFamily: 'Benne',
                      fontWeight: FontWeight.bold,
                      color: context.read(pickedFontProvider).state == 'Benne'
                          ? kSignInButtonColor2
                          : Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    context.read(pickedFontProvider).state = 'BigShoulders';
                    context
                        .read(widgetDataProvider.notifier)
                        .changeFont(_currentIndex.state!, 'BigShoulders');
                  },
                  child: Text(
                    'BigShoulders',
                    style: TextStyle(
                      fontFamily: 'BigShoulders',
                      fontWeight: FontWeight.bold,
                      color: context.read(pickedFontProvider).state ==
                              'BigShoulders'
                          ? kSignInButtonColor2
                          : Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    context.read(pickedFontProvider).state = 'Cinzel';
                    context
                        .read(widgetDataProvider.notifier)
                        .changeFont(_currentIndex.state!, 'Cinzel');
                  },
                  child: Text(
                    'Cinzel',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontWeight: FontWeight.bold,
                      color: context.read(pickedFontProvider).state == 'Cinzel'
                          ? kSignInButtonColor2
                          : Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    context.read(pickedFontProvider).state = 'Fraunces';
                    context
                        .read(widgetDataProvider.notifier)
                        .changeFont(_currentIndex.state!, 'Fraunces');
                  },
                  child: Text(
                    'Fraunces',
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontWeight: FontWeight.bold,
                      color:
                          context.read(pickedFontProvider).state == 'Fraunces'
                              ? kSignInButtonColor2
                              : Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    context.read(pickedFontProvider).state = 'IndieFlower';
                    context
                        .read(widgetDataProvider.notifier)
                        .changeFont(_currentIndex.state!, 'IndieFlower');
                  },
                  child: Text(
                    'IndieFlower',
                    style: TextStyle(
                      fontFamily: 'IndieFlower',
                      fontWeight: FontWeight.bold,
                      color: context.read(pickedFontProvider).state ==
                              'IndieFlower'
                          ? kSignInButtonColor2
                          : Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    context.read(pickedFontProvider).state = 'LobsterTwo';
                    context
                        .read(widgetDataProvider.notifier)
                        .changeFont(_currentIndex.state!, 'LobsterTwo');
                  },
                  child: Text(
                    'LobsterTwo',
                    style: TextStyle(
                      fontFamily: 'LobsterTwo',
                      fontWeight: FontWeight.bold,
                      color:
                          context.read(pickedFontProvider).state == 'LobsterTwo'
                              ? kSignInButtonColor2
                              : Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    context.read(pickedFontProvider).state = 'RobotoMono';
                    context
                        .read(widgetDataProvider.notifier)
                        .changeFont(_currentIndex.state!, 'RobotoMono');
                  },
                  child: Text(
                    'RobotoMono',
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      color:
                          context.read(pickedFontProvider).state == 'RobotoMono'
                              ? kSignInButtonColor2
                              : Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    context.read(pickedFontProvider).state = 'VT323';
                    context
                        .read(widgetDataProvider.notifier)
                        .changeFont(_currentIndex.state!, 'VT323');
                  },
                  child: Text(
                    'VT323',
                    style: TextStyle(
                      fontFamily: 'VT323',
                      fontWeight: FontWeight.bold,
                      color: context.read(pickedFontProvider).state == 'VT323'
                          ? kSignInButtonColor2
                          : Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    context.read(pickedFontProvider).state = 'ShadowsIntoLight';
                    context
                        .read(widgetDataProvider.notifier)
                        .changeFont(_currentIndex.state!, 'ShadowsIntoLight');
                  },
                  child: Text(
                    'ShadowsIntoLight',
                    style: TextStyle(
                      fontFamily: 'ShadowsIntoLight',
                      fontWeight: FontWeight.bold,
                      color: context.read(pickedFontProvider).state ==
                              'ShadowsIntoLight'
                          ? kSignInButtonColor2
                          : Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
              ],
            ),
          ),
          //choose color blocks
          Row(
            children: [
              FastColorPicker(
                onColorSelected: (color) {
                  context
                      .read(widgetDataProvider.notifier)
                      .changeColor(_currentIndex.state!, color);
                  context.read(pickedColorProvider).state = color;
                },
                selectedColor: _pickedColor.state!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OutlineWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _currentIndex = watch(selectedWidgetIndexProvider);
    final _pickedOutlineColor = watch(pickedOutlineColorProvider);
    final _outlineSizeSlider = watch(outlineSizeSliderProvider);
    final _textSizeSlider = watch(textSizeSliderProvider);
    final _pickedBackgroundColor = watch(pickedBackgroundColorProvider);
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      height: MediaQuery.of(context).size.height * 0.26,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //change outline width slider
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Slider(
                  activeColor: kPrimaryColor,
                  value: _outlineSizeSlider.state!,
                  onChanged: (outlineSize) {
                    context.read(outlineSizeSliderProvider).state = outlineSize;
                    _outlineSizeSlider.state != 4
                        ? context
                            .read(widgetDataProvider.notifier)
                            .changeOutlineSize(
                                _currentIndex.state!, outlineSize)
                        : context
                            .read(widgetDataProvider.notifier)
                            .changeBackgroundColor(_currentIndex.state!,
                                _pickedOutlineColor.state!);
                  },
                  min: 0,
                  max: 4,
                  divisions: 4,
                  label: getOutlineWidth(_outlineSizeSlider.state!),
                ),
              ),
            ],
          ),
          //choose color blocks
          Row(
            children: [
              FastColorPicker(
                onColorSelected: (color) {
                  _outlineSizeSlider.state != 4
                      ? context
                          .read(widgetDataProvider.notifier)
                          .changeOutlineColor(_currentIndex.state!, color)
                      : context
                          .read(widgetDataProvider.notifier)
                          .changeBackgroundColor(_currentIndex.state!, color);
                  context.read(pickedOutlineColorProvider).state = color;
                },
                selectedColor: _pickedOutlineColor.state!,
              )
            ],
          ),
        ],
      ),
    );
  }

  String getOutlineWidth(outlineWidth) {
    if (outlineWidth == 0) {
      return 'Zero';
    } else if (outlineWidth == 1) {
      return 'Thin';
    } else if (outlineWidth == 2) {
      return 'Medium';
    } else if (outlineWidth == 3) {
      return 'Thick';
    } else {
      return 'Full';
    }
  }
}
