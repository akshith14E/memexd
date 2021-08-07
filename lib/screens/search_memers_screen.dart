import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/controllers/search_memers_controller.dart';
import 'package:memexd/widgets/custom_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/widgets/network_error_screen.dart';
import 'package:memexd/widgets/progress_indicator.dart';
import 'package:memexd/widgets/search_memer_tile.dart';

class SearchMemersScreen extends StatefulWidget {
  static String get id => 'Search_Memers_Screen';
  @override
  _SearchMemersScreenState createState() => _SearchMemersScreenState();
}

class _SearchMemersScreenState extends State<SearchMemersScreen> {
  String searchString = '';
  final textFieldValueHolder = TextEditingController();

  StreamSubscription? subscription;
  InternetConnectionStatus networkStatus = InternetConnectionStatus.connected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      networkStatus = status;
      print(status.toString());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return networkStatus == InternetConnectionStatus.connected
        ? Scaffold(
            appBar: customAppbar(context),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: textFieldValueHolder,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (value) {
                          setState(() {
                            searchString = value;
                          });
                          if (value != '')
                            context.read(searchMemersProvider.notifier)
                              ..query(value.toLowerCase());
                        },
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                            color: Colors.black),
                        cursorColor: Colors.black,
                        cursorHeight:
                            MediaQuery.of(context).size.height * 0.028,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          suffixIcon: IconButton(
                            padding: EdgeInsets.only(bottom: 10, top: 5),
                            splashRadius: 0.001,
                            onPressed: () {
                              setState(() {
                                searchString = textFieldValueHolder.text;
                              });
                              if (textFieldValueHolder.text != '')
                                context.read(searchMemersProvider.notifier)
                                  ..query(
                                      textFieldValueHolder.text.toLowerCase());
                            },
                            icon: Icon(Icons.search),
                            color: Colors.grey[600],
                            iconSize: MediaQuery.of(context).size.height * 0.04,
                          ),
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          enabledBorder: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    indent: 5,
                    endIndent: 5,
                    thickness: 1.5,
                  ),
                  searchString == ""
                      ? Center(child: Text('Search For Users'))
                      : Consumer(
                          builder: (context, watch, child) {
                            return watch(searchMemersProvider).when(
                                data: (_) => Expanded(
                                      child: SearchMemersTile(
                                          watch(searchMemersProvider)
                                              .data!
                                              .value),
                                    ),
                                loading: () => Progress(),
                                error: (_, _s) => Container());
                          },
                        ),
                ],
              ),
            ),
          )
        : NetworkErrorScreen();
  }
}
