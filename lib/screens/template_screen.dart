import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memexd/controllers/showing_template_controller.dart';
import 'package:memexd/providers/editor_providers.dart';
import 'package:memexd/services/get_templates.dart';
import 'package:memexd/services/image_services.dart';
import 'package:memexd/widgets/showing_templates.dart';
import '../models/template_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'editor_screen.dart';
import 'home_screen.dart';

class TemplateScreen extends StatefulWidget {
  static const String id = 'TemplateScreen';

  @override
  _TemplateScreenState createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  File? _selectedFile;
  final picker = ImagePicker();
  String searchString = '';
  bool showFABSheet = false;
  List<TemplateData> templates = [];
  FocusNode _focus = FocusNode();

  @override
  void initState() {
    GetTemplates getTemplates = GetTemplates();
    getTemplates.getLocalTemplate().then((value) => templates = value!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  bool showFAB =true;
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 0.04 * MediaQuery.of(context).size.width,
                    bottom: 0.04 * MediaQuery.of(context).size.width,
                    right: 0.03 * MediaQuery.of(context).size.width,
                    left: 0.03 * MediaQuery.of(context).size.width),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.002,
                              bottom:
                                  MediaQuery.of(context).size.height * 0.002,
                            ),
                            width: MediaQuery.of(context).size.width * 0.77,
                            height:
                                MediaQuery.of(context).size.height * 0.065,
                            child: FocusScope(
                              child: Focus(
                                onFocusChange: (focus){
                                 setState(() {
                                   showFAB = !showFAB;
                                 });
                                },
                                child: TextFormField(
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .color,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      searchString = value;
                                    });
                                    if (value != '')
                                      context
                                          .read(showingTemplatesProvider.notifier)
                                          .search(value.toLowerCase(), templates);
                                  },
                                  decoration: InputDecoration(
                                    focusColor: Colors.black,
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                    hintText: 'Search templates',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color,
                                    ),
                                    filled: true,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(7),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.height * 0.015,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: IconButton(
                              icon: Image.asset(
                                'images/refreshing.png',
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                              ),
                              onPressed: () {
                                context
                                    .read(showingTemplatesProvider.notifier)
                                    .shuffle();
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width:
                                  MediaQuery.of(context).size.height * 0.0008,
                            ),
                          ),
                        ),
                        child: TabBar(
                          indicatorColor:
                              Theme.of(context).textTheme.bodyText2!.color,
                          indicatorWeight: 3.5,
                          labelColor:
                              Theme.of(context).textTheme.bodyText2!.color,
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize:
                                MediaQuery.of(context).size.width * 0.0335,
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: [
                            Tab(
                              text: 'All',
                            ),
                            Tab(
                              text: 'Indian',
                            ),
                            Tab(
                              text: 'International',
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 0.015 * MediaQuery.of(context).size.height,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            ShowingTemplates('All'),
                            ShowingTemplates('In'),
                            ShowingTemplates('It'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              showFABSheet ? FABSheet() : Container(),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: Visibility(
            visible: showFAB,
            child:    Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.21),
              child: Container(
                height: MediaQuery.of(context).size.height * .06,
                width: MediaQuery.of(context).size.height * .06,
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  onPressed: () {
                    setState(() {
                      showFABSheet = !showFABSheet;
                    });
                  },
                  elevation: 10,
                  backgroundColor: Color(0xff38808F),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  void afterBuild() {
    context.read(showingTemplatesProvider.notifier).show(templates);
  }
}

class FABSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Padding(
      padding: EdgeInsets.only(
          //bottom: MediaQuery.of(context).size.height * 0.06,

          ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .07, top: 10),
          height: MediaQuery.of(context).size.height * 0.295,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            color: Theme.of(context).backgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.filter,
                    size: 25,
                  ),
                  TextButton(
                    onPressed: () async {
                      context.read(customTemplateProvider).state =
                          await imagePickCropDynamic(ImageSource.gallery);
                      context.read(templateImageProvider).state = null;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditorScreen(url: 'g')));
                    },
                    child: Text(
                      'Import from gallery',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.add_a_photo,
                    size: 25,
                  ),
                  TextButton(
                    onPressed: () async {
                      context.read(customTemplateProvider).state =
                          await imagePickCrop(ImageSource.camera);
                      context.read(templateImageProvider).state = null;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditorScreen(url: 'g')));
                    },
                    child: Text(
                      'Capture from Camera',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.check_box_outline_blank_outlined,
                    size: 25,
                  ),
                  TextButton(
                    onPressed: () {

                      context.read(templateImageProvider).state = null;
                      context.read(customTemplateProvider).state = null;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditorScreen(url: 'g')));
                    },
                    child: Text(
                      'Use blank template',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
