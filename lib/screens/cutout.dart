import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as Img;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/controllers/theme_controller.dart';
import 'package:memexd/providers/shared_preferences_provider.dart';
import 'package:memexd/screens/editor_screen.dart';
import 'package:memexd/services/image_services.dart';
import 'package:memexd/widgets/custom_dialog_box.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/providers/editor_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

Uint8List? byteList;
bool flipImage = false;
var recorder;
var canvas;
var brushSize = 15.0;
bool themeState = false;

enum WidgetMarker { none, flip, auto, manual}

class Cutout extends StatefulWidget {
  final String? pickedStickerfromPhone;
  const Cutout({Key? key, this.pickedStickerfromPhone}) : super(key: key);
  static const String id = 'Cutout';

  @override
  _CutoutState createState() => _CutoutState(pickedStickerfromPhone!);
}

class _CutoutState extends State<Cutout> {
  WidgetMarker selectedWidgetMarker = WidgetMarker.none;
  ui.Image? image;
  String path;

  _CutoutState(this.path);
  
  @override
  void initState() {
    super.initState();

    loadImage(path);
  }

  Future loadImage(String path) async {

    // final data = await rootBundle.load(path);
    final bytes = File(path).readAsBytesSync();
    final image = await decodeImageFromList(bytes);
    var theme = ThemeController(await SharedPreferences.getInstance()).getTheme();

    setState(() {
      this.image = image;
      byteList = bytes;
      themeState = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.only(
              top: MediaQuery
                  .of(context)
                  .padding
                  .top,
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.01,
              right: MediaQuery
                  .of(context)
                  .size
                  .width * 0.01),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialogBox(
                          title: 'Close Cutout Activity?',
                          contentText: 'Your work will be lost',
                          action1Text: 'Yes',
                          action2Text: 'No',
                          action1onPressed: () {
                            context
                                .read(widgetDataProvider.notifier)
                                .clearState();
                            Navigator.of(context).pop();
                            Navigator.pop(context,EditorScreen.id);
                          },
                          action2onPressed: (){Navigator.of(context).pop();},
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_back_ios),
                    splashRadius: 20.0,
                  ),
                  IconButton(
                    onPressed: () async {
                      if (recorder.isRecording) {
                        ui.Picture picture = recorder.endRecording();
                        ui.Image imageEx = await picture.toImage(
                            image!.width, image!.height);
                        var pngBytes = await imageEx.toByteData(format: ui
                            .ImageByteFormat.png);
                        byteList = pngBytes!.buffer.asUint8List();
                      }
                      //Todo Add the return byteList here
                      context
                          .read(cutoutImageProvider)
                          .state = byteList;
                      Navigator.pop(context, byteList);
                    },
                    icon: Icon(Icons.check),
                    splashRadius: 20.0,
                  ),
                ],
              ),
              Container(
                // margin: const EdgeInsets.all(30.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: kPrimaryColor)),
                child: FittedBox(
                  child: SizedBox(
                    height: image!.height.toDouble(),
                    width: image!.width.toDouble(),
                    //child: AutomaticBGRemoval(),
                    child: getCustomWidget(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  IconButton(
                    onPressed: () async {
                      if (recorder.isRecording) {
                        ui.Picture picture = recorder.endRecording();
                        ui.Image imageEx = await picture.toImage(
                            image!.width, image!.height);
                        var pngBytes = await imageEx.toByteData(format: ui
                            .ImageByteFormat.png);
                        byteList = pngBytes!.buffer.asUint8List();
                      }
                      setState(() {
                        selectedWidgetMarker = WidgetMarker.auto;
                        flipImage = false;
                      });
                    },
                    icon: Icon(TablerIcons.wand),
                    color: selectedWidgetMarker == WidgetMarker.auto
                        ? kPrimaryColor
                        : Colors.grey,),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectedWidgetMarker = WidgetMarker.manual;
                        flipImage = false;
                      });
                    },
                    icon: Icon(TablerIcons.eraser),
                    color: selectedWidgetMarker == WidgetMarker.manual
                        ? kPrimaryColor
                        : Colors.grey,),
                  IconButton(
                      onPressed: () {
                        loadImage(path);
                        selectedWidgetMarker = WidgetMarker.none;
                        flipImage = false;
                      },
                      icon: Icon(Icons.undo)),
                ],
              ),
            ],
          ),
        ),
      );
    }
    else {
      return Container();
    }


  }
  Widget getCustomWidget() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.auto:
        return AutomaticBGRemoval();
      case WidgetMarker.manual:
        return ManualRemoval();
      default:
        {
          print(byteList!.length);
          return Image.memory(byteList!);
        }
    }
  }
}


class ManualRemoval extends StatefulWidget {
  @override
  _ManualRemovalState createState() => _ManualRemovalState();
}

class _ManualRemovalState extends State<ManualRemoval> {
  ui.Image? image;
  GlobalKey globalKey = GlobalKey();

  var paint, paint1;
  @override
  void initState() {
    super.initState();

    loadImage('images/memexdlogo.png');
    recorder = new ui.PictureRecorder();

    paint1 = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    paint = Paint();
    paint.blendMode = BlendMode.clear;
    paint.color = Colors.transparent;
    paint.strokeWidth = 20.0;
  }

  loadImage(String path) async {
    // final data = await rootBundle.load(path);
    // final bytes = data.buffer.asUint8List();
    image = await decodeImageFromList(byteList!);
    canvas = new Canvas(
        recorder,
        new Rect.fromPoints(new Offset(0.0, 0.0),
            new Offset(image!.width.toDouble(), image!.height.toDouble())));
    canvas.drawImage(image, Offset.zero, paint1);

    setState(() => this.image = image);
  }

  List<Offset> points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    Sketcher sketcher = Sketcher(points, image);
    Container sketchArea = Container();
    if(image!=null)
    {
     sketchArea =
        Container(
          //margin: EdgeInsets.all(1.0),
          alignment: Alignment.topLeft,
          height: image!.height.toDouble(),
          width: image!.width.toDouble(),
          child: CustomPaint(
            size: Size(image!.width.toDouble(), image!.width.toDouble()),
            painter: sketcher,
          ),
        );
      }


    return Container(

        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              Offset point = details.localPosition;
              if((point.dy > 0 && point.dx > 0 && point.dx < image!.width && point.dy < image!.height ))
                {
                  canvas.drawCircle(point, 20.00, paint);
                  points = List.from(points)..add(point);
                }
              // point = point.translate(0.0, -(AppBar().preferredSize.height));
            });
          },
          onPanEnd: (DragEndDetails details) {
            // points.add(null);
          },
          child: sketchArea,
        ),

      // floatingActionButton: FloatingActionButton(
      //   tooltip: 'clear Screen',
      //   backgroundColor: Colors.transparent,
      //   onPressed: () async {
      //     ui.Picture picture = recorder.endRecording();
      //     ui.Image imageEx = await picture.toImage(image!.width, image!.height);
      //     var pngBytes = await imageEx.toByteData(format: ui.ImageByteFormat.png);
      //     Directory? appDocDir = await getExternalStorageDirectory();
      //     File('${appDocDir!.path}/filename.png')
      //         .writeAsBytesSync(pngBytes!.buffer.asInt8List());
      //     File('${appDocDir.path}/filename.png').readAsString().then((String contents) {
      //       print(contents);
      //     });
      //     points.clear();
      //
      //     },
      //   child: Icon(Icons.refresh),
      // ),
    );
  }
}

class Sketcher extends CustomPainter {
  final ui.Image? image;

  final List<Offset> points;
  Size? lastSize;

  Sketcher(this.points, this.image);

  bool shouldRepaint(Sketcher oldDelegate) {
    return oldDelegate.points != points;
  }

  void paint(Canvas canvas, Size size) {
    lastSize = size;
    Paint paint1 = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    canvas.drawImage(image!, Offset.zero, paint1);
    Paint paint = Paint();
    paint.blendMode = BlendMode.src;
    paint.color = themeState ? kAppBackgroundColorLight : kAppBackgroundColorDark;
    paint.strokeWidth = 20.0;

    for (int i = 0; i < points.length - 1; i++) {
      // canvas.drawLine(points[i], points[i + 1], paint);
      canvas.drawCircle(points[i], brushSize, paint);
    }
  }
}

//OneClick Background Removal
const COLOR_TOLERANCE = 20;

class AutomaticBGRemoval extends StatefulWidget {
  @override
  _AutomaticBGRemovalState createState() => _AutomaticBGRemovalState();
}

class _AutomaticBGRemovalState extends State<AutomaticBGRemoval> {
  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: ImagePixels(
              imageProvider: MemoryImage(byteList!),
              builder: (context, img) {
                return GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      offset = Offset(
                          details.localPosition.dx, details.localPosition.dy);
                      var color = img.pixelColorAt!(
                          details.localPosition.dx.toInt(),
                          details.localPosition.dy.toInt());
                      byteList = removeBackground(byteList!, color);
                    });
                  },
                  child: Image.memory(byteList!),
                );
              }),
        ),
      ),
    );
  }

  Uint8List? removeBackground(Uint8List bytes, Color color) {
    Img.Image? img = Img.decodeImage(bytes);
    int rrA = color.alpha;
    int rrR = color.red;
    int rrG = color.green;
    int rrB = color.blue;

    Img.Image transparentImage = colorTransparent(img!, rrR, rrG, rrB);
    var newPng = Img.encodePng(transparentImage) as Uint8List;
    return newPng;
  }

  Img.Image colorTransparent(Img.Image src, int red, int green, int blue) {
    var pixels = src.getBytes();

    for (int i = 0, len = pixels.length; i < len; i += 4) {
      if (red - COLOR_TOLERANCE < pixels[i] &&
          pixels[i] < red + COLOR_TOLERANCE &&
          green - COLOR_TOLERANCE < pixels[i + 1] &&
          pixels[i + 1] < green + COLOR_TOLERANCE &&
          blue - COLOR_TOLERANCE < pixels[i + 2] &&
          pixels[i + 2] < blue + COLOR_TOLERANCE) {
        pixels[i + 3] = 0;
      }
    }
    return src;
  }
}
