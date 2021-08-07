import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:memexd/editorwidgets/add_text_widget.dart';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/editorwidgets/add_sticker.dart';
import 'package:memexd/editorwidgets/add_text_widget.dart';

import 'package:memexd/editorwidgets/eraser_widget.dart';
import 'package:memexd/models/widget_data.dart';
import 'package:memexd/models/widget_model.dart';
import 'package:memexd/providers/editor_providers.dart';
import 'package:memexd/screens/post_screen.dart';
import 'package:memexd/screens/template_example_screen.dart';
import 'package:memexd/screens/template_screen.dart';
import 'package:memexd/services/ad_helper.dart';
import 'package:memexd/services/ad_helper.dart';
import 'package:memexd/services/ad_helper.dart';
import 'package:memexd/services/image_services.dart';
import 'package:memexd/widgets/LoaderDialog.dart';
import 'package:memexd/widgets/custom_app_bar.dart';
import 'package:memexd/widgets/custom_dialog_box.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'package:screenshot/screenshot.dart';
import 'home_screen.dart';

enum WidgetMarker1 { none, sticker, text, delete }
enum WidgetType { Image, Text }

class EditorScreen extends ConsumerWidget {
  static const String id = 'EditorScreen';
  final String? url;
  WidgetModel? _activeItem;
  final GlobalKey globalKey = new GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

  Offset? _initPos;
  Offset? _currentPos;
  double? _currentScale;
  double? _currentRotation;
  bool _inAction = false;
  Size? screen;

  RewardedAds adObject = RewardedAds();

  EditorScreen({this.url});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    screen = MediaQuery.of(context).size;

    final _showTextWidget = watch(showTextWidgetProvider);
    final _showStickerWidget = watch(showStickerWidgetProvider);
    final _showDeleteWidget = watch(showDeleteWidgetProvider);
    final selectedWidgetMarker1 = watch(selectedWidgetMarker1Provider);
    final _selectedWidget = watch(selectedWidgetProvider);
    final _workspaceBorderColor = watch(workspaceBorderColorProvider);

    final widgetList = watch(widgetDataProvider);

    adObject.loadRewardedAd();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
        child: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: Container(),
          backgroundColor: Theme.of(context).primaryColor,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.04,
                  width: MediaQuery.of(context).size.width * 0.08,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('images/memexdlogo.png'),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Center(
                  child: Text(
                    'MEMEXD',
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).backgroundColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                      letterSpacing: 4,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.16,
                ),
              ],
            ),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          showDialog(
            context: context,
            builder: (context) => CustomDialogBox(
              title: 'Close Editor ?',
              contentText: 'Your work will be lost',
              action1Text: 'Yes',
              action2Text: 'No',
              action1onPressed: () {
                context.read(widgetDataProvider.notifier).clearState();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Home(selectedScreen: 2);
                    },
                  ),
                );
              },
              action2onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
          return Future.value(false);
        },
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                ),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => CustomDialogBox(
                                  title: 'Close Editor ?',
                                  contentText: 'Your work will be lost',
                                  action1Text: 'Yes',
                                  action2Text: 'No',
                                  action2onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  action1onPressed: () {
                                    context
                                        .read(widgetDataProvider.notifier)
                                        .clearState();
                                    Navigator.of(context).pop();
                                    // Navigator.of(context).pushReplacement(
                                    //   MaterialPageRoute(
                                    //     builder: (BuildContext context) {
                                    //       return Home(selectedScreen: 2);
                                    //     },
                                    //   ),
                                    // );
                                    Navigator.of(context).pop();
                                  },
                                ),
                              );
                            },
                            splashRadius: 20.0,
                          ),
                          IconButton(
                            icon: Icon(Icons.undo),
                            onPressed: () {
                              context
                                  .read(widgetDataProvider.notifier)
                                  .undoOperation();
                            },
                            splashRadius: 20.0,
                          ),
                          IconButton(
                            icon: Icon(Icons.lightbulb),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TemplateExampleScreen(url: url),
                                ),
                              );
                            },
                            splashRadius: 20.0,
                          ),
                          IconButton(
                            icon: Icon(Icons.redo),
                            onPressed: () {
                              context
                                  .read(widgetDataProvider.notifier)
                                  .redoOperation();
                            },
                            splashRadius: 20.0,
                          ),
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              adObject.loadRewardedAd();

                              context.read(selectedWidgetProvider).state = -1;
                              showDialog(
                                context: context,
                                builder: (globalDialogKey) => CustomDialogBox(
                                  title: "Remove Watermark?",
                                  contentText:
                                      "One ad is all that it'll take to remove the watermark!",
                                  action1Text: 'Remove',
                                  action2Text: 'Continue',
                                  action2onPressed: () {
                                    Navigator.pop(context);
                                    print('Continue pressed');

                                    takeScreenshot(context, true);
                                  },
                                  action1onPressed: () {
                                    bool watermark = true;
                                    Navigator.pop(context);
                                    adObject.rewardedAd!
                                            .fullScreenContentCallback =
                                        FullScreenContentCallback(
                                      onAdShowedFullScreenContent:
                                          (RewardedAd ad) => print(
                                              '$ad onAdShowedFullScreenContent.'),
                                      onAdDismissedFullScreenContent:
                                          (RewardedAd ad) {
                                        print(
                                            '$ad onAdDismissedFullScreenContent.');
                                        ad.dispose();
                                        takeScreenshot(context, watermark);
                                      },
                                      onAdFailedToShowFullScreenContent:
                                          (RewardedAd ad, AdError error) {
                                        print(
                                            '$ad onAdFailedToShowFullScreenContent: $error');
                                        ad.dispose();
                                        takeScreenshot(context, watermark);
                                      },
                                      onAdImpression: (RewardedAd ad) =>
                                          print('$ad impression occurred.'),
                                    );
                                    adObject.rewardedAd!.show(
                                        onUserEarnedReward:
                                            (RewardedAd ad, RewardItem points) {
                                      watermark = false;
                                      print('Rewarded with $points points');
                                    });
                                  },
                                ),
                              );
                            },
                            splashRadius: 20.0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: GestureDetector(
                            onTapDown: (details) {
                              if (_activeItem == null) {
                                context.read(selectedWidgetProvider).state = -1;
                              }
                              _showDeleteWidget.state = false;
                              context
                                  .read(selectedWidgetMarker1Provider)
                                  .state = WidgetMarker1.none;
                            },
                            onTapUp: (details) {
                              if (_inAction == false) {
                                context.read(selectedWidgetProvider).state = -1;
                              }
                              _showDeleteWidget.state = false;
                            },
                            onScaleStart: (details) {
                              if (_activeItem == null) return;

                              _initPos = details.focalPoint;
                              _currentPos = _activeItem!.position!;
                              _currentScale = _activeItem!.scale!;
                              _currentRotation = _activeItem!.rotation!;
                              context.read(widgetDataProvider.notifier).savePos(
                                  _activeItem!.widgetId!, _currentPos!);
                            },
                            onScaleUpdate: (details) {
                              if (_activeItem == null) return;
                              final delta = details.focalPoint - _initPos!;
                              final left =
                                  (delta.dx / screen!.width) + _currentPos!.dx;
                              final top =
                                  (delta.dy / screen!.height) + _currentPos!.dy;

                              context
                                  .read(widgetDataProvider.notifier)
                                  .changePosition(_activeItem!.widgetId!,
                                      Offset(left, top));
                              var finalRot =
                                  details.rotation + _currentRotation!;

                              if (finalRot % (pi / 2) < 0.12 &&
                                  finalRot % (pi / 2) > -0.12) {
                                finalRot = finalRot - finalRot % (pi / 2);
                              }
                              context
                                  .read(widgetDataProvider.notifier)
                                  .changeRotation(
                                      _activeItem!.widgetId!, finalRot);
                              if (_activeItem!.type != 0) {
                                context
                                    .read(widgetDataProvider.notifier)
                                    .changeScale(
                                        _activeItem!.widgetId!,
                                        max(
                                            min(details.scale * _currentScale!,
                                                3),
                                            0.2));
                              }
                            },
                            onScaleEnd: (details) {
                              _inAction = false;
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _workspaceBorderColor.state!,
                                    width: 2),
                              ),
                              child: Container(
                                child: Screenshot(
                                  controller: screenshotController,
                                  child: Stack(
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          // margin: EdgeInsets.all(
                                          //     MediaQuery.of(context).size.width *
                                          //         0.004),
                                          child: watch(templateImageProvider)
                                                      .state !=
                                                  null
                                              ? watch(templateImageProvider)
                                                  .state
                                              : watch(customTemplateProvider)
                                                          .state !=
                                                      null
                                                  ? Image(
                                                      image: FileImage(
                                                        File(watch(
                                                                customTemplateProvider)
                                                            .state!),
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      'images/blank_template.png')),
                                      ...widgetList
                                          .map(_buildItemWidget)
                                          .toList(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.text_fields),
                            iconSize: MediaQuery.of(context).size.width * 0.06,
                            onPressed: () {
                              selectedWidgetMarker1.state = WidgetMarker1.text;
                              _showStickerWidget.state = false;
                              _showDeleteWidget.state = false;

                              context.read(showTextWidgetProvider).state =
                                  !_showTextWidget.state;
                              context
                                  .read(widgetDataProvider.notifier)
                                  .addText();
                              context.read(selectedWidgetIndexProvider).state =
                                  widgetList.length;
                              context.read(selectedWidgetProvider).state =
                                  widgetList.length;
                              if (_showTextWidget.state) {
                                selectedWidgetMarker1.state =
                                    WidgetMarker1.text;
                              } else {
                                selectedWidgetMarker1.state =
                                    WidgetMarker1.none;
                                _showDeleteWidget.state = false;
                                _showTextWidget.state = false;
                              }
                            },
                            color: (selectedWidgetMarker1.state ==
                                    WidgetMarker1.text)
                                ? kBottomNavigationBar
                                : Colors.grey,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline_outlined),
                            iconSize: MediaQuery.of(context).size.width * 0.06,
                            onPressed: () {
                              selectedWidgetMarker1.state =
                                  WidgetMarker1.delete;
                              _showStickerWidget.state = false;
                              _showTextWidget.state = false;

                              context.read(showDeleteWidgetProvider).state =
                                  !_showDeleteWidget.state;
                              if (_showDeleteWidget.state) {
                                selectedWidgetMarker1.state =
                                    WidgetMarker1.delete;
                                context
                                    .read(widgetDataProvider.notifier)
                                    .deleteWidget(
                                        watch(selectedWidgetIndexProvider)
                                            .state!);
                              } else {
                                selectedWidgetMarker1.state =
                                    WidgetMarker1.none;
                                _showDeleteWidget.state = false;
                                _showTextWidget.state = false;
                              }
                            },
                            color: (selectedWidgetMarker1.state ==
                                    WidgetMarker1.delete)
                                ? kBottomNavigationBar
                                : Colors.grey,
                          ),
                          IconButton(
                            icon: Icon(Icons.image),
                            iconSize: MediaQuery.of(context).size.width * 0.06,
                            onPressed: () {
                              selectedWidgetMarker1.state =
                                  WidgetMarker1.sticker;
                              _showTextWidget.state = false;
                              _showDeleteWidget.state = false;

                              context.read(showStickerWidgetProvider).state =
                                  !_showStickerWidget.state;
                              if (_showStickerWidget.state) {
                                selectedWidgetMarker1.state =
                                    WidgetMarker1.sticker;
                              } else {
                                selectedWidgetMarker1.state =
                                    WidgetMarker1.none;
                                _showDeleteWidget.state = false;
                                _showTextWidget.state = false;
                              }
                            },
                            color: (selectedWidgetMarker1.state ==
                                    WidgetMarker1.sticker)
                                ? kBottomNavigationBar
                                : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    selectedWidgetMarker1.state == WidgetMarker1.none
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: BannerAdsWidget(),
                          )
                        : Container()
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: getCustomWidget(selectedWidgetMarker1.state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemWidget(WidgetModel e) {
    var widget;
    switch (e.type) {
      case 0:
        widget = Text(
          e.text!,
          style: TextStyle(
            color: e.color,
            backgroundColor: e.backgroundColor,
            fontFamily: e.style,
            fontSize: e.size,
            shadows: [
              Shadow(
                  // bottomLeft
                  offset: Offset(-(e.outlineSize!), -(e.outlineSize!)),
                  color: e.outlineColor!),
              Shadow(
                  // bottomRight
                  offset: Offset((e.outlineSize!), -(e.outlineSize!)),
                  color: e.outlineColor!),
              Shadow(
                  // topRight
                  offset: Offset((e.outlineSize!), (e.outlineSize!)),
                  color: e.outlineColor!),
              Shadow(
                  // topLeft
                  offset: Offset(-(e.outlineSize!), (e.outlineSize!)),
                  color: e.outlineColor!),
            ],
          ),
        );
        break;
      case 1: // in built stickers
        widget = Image.asset(e.imagePath!);
        break;
      case 2:
        widget = Image.memory(e.bytes!);
        break;
    }
    return Consumer(
      builder: (BuildContext context, watch, child) {
        return Positioned(
          top: e.position!.dy * screen!.height,
          left: e.position!.dx * screen!.width,
          child: Transform.scale(
            scale: e.scale!,
            child: Transform.rotate(
              angle: e.rotation!,
              child: GestureDetector(
                onDoubleTap: () {
                  if (e.type == 0)
                    watch(selectedWidgetMarker1Provider).state =
                        WidgetMarker1.text;
                  if (_inAction) return;
                  _inAction = true;
                  _activeItem = e;
                  _currentPos = e.position;
                  _currentScale = e.scale;
                  _currentRotation = e.rotation;
                  context.read(selectedWidgetIndexProvider).state = e.widgetId!;
                  context.read(selectedWidgetProvider).state = e.widgetId!;
                },
                onTapDown: (details) {
                  if (_inAction) return;
                  _inAction = true;
                  _activeItem = e;
                  _initPos = details.globalPosition;
                  _currentPos = e.position;
                  _currentScale = e.scale;
                  _currentRotation = e.rotation;

                  context.read(selectedWidgetIndexProvider).state = e.widgetId!;
                  context.read(selectedWidgetProvider).state = e.widgetId!;
                },
                onTapUp: (details) {
                  _activeItem = null;
                  _inAction = false;
                },
                child: Stack(
                  children: [
                    Container(
                      child: widget,
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: watch(selectedWidgetProvider).state ==
                                    e.widgetId!
                                ? kSignInButtonColor2
                                : Colors.transparent,
                            width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getCustomWidget(WidgetMarker1 widget) {
    switch (widget) {
      case WidgetMarker1.sticker:
        return AddSticker();
      case WidgetMarker1.text:
        return AddTextWidget();
      default:
        return Container();
    }
  }

  takeScreenshot(context, bool watermark) async {
    final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();
    LoaderDialog.showLoadingDialog(context, _LoaderDialog);
    screenshotController.capture().then((var image) async {
      Directory? appDocDir = await getTemporaryDirectory();
      File('${appDocDir.path}/postMeme.png')
          .writeAsBytesSync(image!.buffer.asInt8List());
      var fileImage = File('${appDocDir.path}/postMeme.png');
      Navigator.of(_LoaderDialog.currentContext!, rootNavigator: true).pop();

      var croppedImagePath = await imageCropDynamic(fileImage.path);
      Uint8List croppedImage = File(croppedImagePath!).readAsBytesSync();

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PostScreen(
              finalImage: croppedImage,
              templateKey: url,
              watermark: watermark)));
    }).catchError((onError) {
      print(onError);
    });
  }

// void DialogBoxAction1(context){
//   Navigator.pushNamed(context, TemplateScreen.id);
// }
// void DialogBoxAction2(context){
//   Navigator.pushNamed(context, TemplateScreen.id);
// }
}
