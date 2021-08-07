import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:memexd/controllers/add_posts_controller.dart';
import 'package:memexd/providers/editor_providers.dart';
import 'package:memexd/screens/home_screen.dart';
import 'package:memexd/services/ad_helper.dart';
import 'package:memexd/services/add_watermark.dart';
import 'package:memexd/services/get_user_data.dart';
import 'package:memexd/widgets/custom_dialog_box.dart';
import 'package:memexd/widgets/network_error_screen.dart';
import 'package:memexd/widgets/progress_indicator.dart';
import 'package:memexd/widgets/rate_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

final InAppReview inAppReview = InAppReview.instance;
SharedPreferences? prefs;
bool? shouldShowRateDialog = true;

class PostScreen extends StatefulWidget {
  final Uint8List? finalImage;
  final String? templateKey;
  final bool? watermark;

  PostScreen({this.finalImage, this.templateKey, this.watermark});

  static const String id = 'PostScreen';

  @override
  _PostScreenState createState() =>
      _PostScreenState(finalImage!, templateKey, watermark!);
}

class _PostScreenState extends State<PostScreen> {
  final _textController = TextEditingController();
  List<String> imagePaths = [];
  ui.Image? image;
  var imageByte;
  Uint8List? fileUint;
  File? fileImage;
  String? username;
  String? templateKey;
  int? numOfPosts;
  bool watermark;

  _PostScreenState(this.fileUint, this.templateKey, this.watermark);

  bool _isButtonDisabled1 = false;
  bool _isButtonDisabled2 = false;

  StreamSubscription? subscription;
  InternetConnectionStatus networkStatus = InternetConnectionStatus.connected;
  bool isVisible = true;

  @override
  void initState() {
    _isButtonDisabled1 = false;
    _isButtonDisabled2 = false;
    super.initState();
    getWatermarkImage(fileUint).whenComplete(() {
      setState(() {});
    });
    getRatingCondition();
    subscription = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      networkStatus = status;
      print(status.toString());
      setState(() {});
    });
  }

  getRatingCondition() async {
    prefs = await SharedPreferences.getInstance();
    shouldShowRateDialog = prefs!.getBool('rate');
    if (shouldShowRateDialog == null) {
      shouldShowRateDialog = await prefs!.setBool('rate', true);
    }
  }

  @override
  void dispose() {
    fileImage = null;
    fileUint = null;
    super.dispose();
  }

  getWatermarkImage(Uint8List? imageFile) async {
    if (watermark) {
      username = await GetUserData().getUsername();
      // Uint8List imageFile = fileImage!.readAsBytesSync();
      ui.Image tempImage = await decodeImageFromList(imageFile!);
      image = await addWatermark(tempImage, username!);
      imageByte = await image!.toByteData(format: ui.ImageByteFormat.png);
    } else {
      imageByte = imageFile;
    }
    Directory? appDocDir = await getTemporaryDirectory();
    File('${appDocDir.path}/postMeme.png').deleteSync();
    File('${appDocDir.path}/postMeme.png')
        .writeAsBytesSync(imageByte!.buffer.asInt8List());
    fileImage = File('${appDocDir.path}/postMeme.png');
  }

  @override
  Widget build(BuildContext context) {
    return networkStatus == InternetConnectionStatus.connected
        ? WillPopScope(
            onWillPop: () {
              _isButtonDisabled1 ? null : Navigator.of(context).pop();
              return Future.value(false);
            },
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                leading: Visibility(
                  visible: isVisible,
                  child: IconButton(
                    icon: Icon(
                      Icons.chevron_left_outlined,
                      color: Theme.of(context).backgroundColor,
                    ),
                    onPressed: _isButtonDisabled1
                        ? null
                        : () {
                            context.read(workspaceBorderColorProvider).state =
                                Colors.black54;
                            Navigator.of(context).pop();
                          },
                  ),
                ),
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
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Theme.of(context).backgroundColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                      ),
                    ),
                    onPressed: (_isButtonDisabled1 || _isButtonDisabled2)
                        ? () {
                            if (shouldShowRateDialog!) {
                              showDialog(
                                  context: context,
                                  builder: (context) => RateDialog(
                                        title: "Let us know how we're doing!",
                                        contentText:
                                            "We are always trying to improve what we do and your feedback is invaluable.",
                                        action1Text: 'RATE',
                                        action2Text: 'LATER',
                                        action3Text: 'NEVER',
                                        action1onPressed: () async {
                                          print('RATE pressed');
                                          if (await inAppReview.isAvailable()) {
                                            inAppReview.requestReview();
                                          }
                                          shouldShowRateDialog = await prefs!
                                              .setBool('rate', false);
                                        },
                                        action2onPressed: () async {
                                          shouldShowRateDialog = await prefs!
                                              .setBool('rate', true);
                                          Navigator.of(context).pop();
                                        },
                                        action3onPressed: () async {
                                          shouldShowRateDialog = await prefs!
                                              .setBool('rate', false);
                                          Navigator.of(context).pop();
                                        },
                                      ));
                              print('Dialog Shown');
                            } else {
                              Navigator.of(context)
                                  .pushReplacementNamed(Home.id);
                            }
                          }
                        : () {
                            showDialog(
                              context: context,
                              builder: (context) => CustomDialogBox(
                                contentText:
                                    'You haven\'t posted or shared the meme!',
                                title: 'Be Patient!',
                                action1Text: 'Stay',
                                action2Text: 'Discard meme',
                                action1onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                action2onPressed: () {
                                  context
                                      .read(widgetDataProvider.notifier)
                                      .clearState();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .pushReplacementNamed(Home.id);
                                },
                              ),
                            );
                          },
                  ),
                ],
              ),
              body: WillPopScope(
                onWillPop: () {
                  context.read(workspaceBorderColorProvider).state =
                      Colors.black54;
                  Navigator.pop(context);
                  return Future.value(false);
                },
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Divider(
                        thickness: 1.3,
                      ),
                      Container(
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.02),
                        width: double.infinity,
                        child: imageByte != null
                            ? Image.file(fileImage!)
                            : Container(
                                child: Progress(),
                              ),
                      ),
                      Divider(
                        thickness: 1.3,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.001,
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.024),
                        child: Column(
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.063,
                              child: TextFormField(
                                controller: _textController,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .color,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Enter a caption here...',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .color,
                                  ),
                                  focusColor: Colors.black,
                                  filled: true,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff38808F),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: _isButtonDisabled1
                                        ? null
                                        : () {
                                            setState(() {
                                              _isButtonDisabled1 = true;
                                              isVisible = false;
                                            });
                                            FocusScope.of(context).unfocus();
                                            context
                                                .read(addPostsProvider.notifier)
                                                .addPosts(
                                                  _textController.text,
                                                  username,
                                                  fileImage!,
                                                  templateKey,
                                                );
                                            context
                                                .read(addPostsProvider.notifier)
                                                .increaseNumberOfMemes();
                                            _showToastPost(context);
                                          },
                                    child: Text(
                                      'Post meme',
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).backgroundColor,
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      final pickedFile = fileImage;
                                      if (pickedFile != null) {
                                        setState(() {
                                          _isButtonDisabled2 = true;
                                          isVisible = false;
                                          imagePaths.add(pickedFile.path);
                                        });
                                      }
                                      _onShare(context);
                                      setState(() {
                                        imagePaths.clear();
                                      });
                                    },
                                    child: Text(
                                      'Share Externally',
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).backgroundColor,
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                            ),
                            BannerAdsWidget(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : NetworkErrorScreen();
  }

  void _showToastSave(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Image saved to the device'),
      ),
    );
  }

  void _showToastPost(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Meme posted successfully'),
      ),
    );
  }

  void _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
          text: _textController.text +
              '\nBy via MemexD\nFrom hera pheri, to marvel,create, browse and share thousands of meme templates from around the world.\nDownload the app, now!\n' +
              'https://play.google.com/store/apps/details?id=com.pi14.memexd',
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(_textController.text,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }
}
