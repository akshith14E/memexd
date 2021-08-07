import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/constants/stringX.dart';
import 'package:memexd/controllers/user_profile.dart';
import 'package:memexd/models/profile_user_model.dart';
import 'package:memexd/screens/cutout.dart';
import 'package:memexd/screens/edit_profile_screen.dart';
import 'package:memexd/screens/follow_list_screen.dart';
import 'package:memexd/screens/saved_posts.dart';
import 'package:memexd/screens/searched_user_profile.dart';
import 'package:memexd/screens/user_meme_screen.dart';
import 'package:memexd/services/network_checker.dart';
import 'package:memexd/widgets/app_drawer.dart';
import 'package:memexd/widgets/fading_cube.dart';
import 'package:memexd/widgets/network_error_screen.dart';
import 'package:memexd/widgets/progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/providers/postscreeen_providers.dart';

class ProfileScreen extends StatefulWidget {
  final TabController? tabController;

  ProfileScreen({this.tabController});

  static String get id => 'Profile_Screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  StreamSubscription? subscription;
  InternetConnectionStatus networkStatus = InternetConnectionStatus.connected;

  @override
  void initState() {
    // saveValue("-MKUE_Im3i_8976ySjli");

    super.initState();
    context
        .read(profileUserDataNotifier.notifier)
        .getData(FirebaseAuth.instance.currentUser!.uid);
    context
        .read(profileUserMemesNotifier.notifier)
        .getPosts(FirebaseAuth.instance.currentUser!.uid);
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
        ? Consumer(builder: (context, watch, child) {
            final profileUserData = watch(profileUserDataNotifier);
            final posts = watch(profileUserMemesNotifier);
            return profileUserData.map(

                data: (profileUserData) => SafeArea(
                      child: DefaultTabController(
                        length: 2,
                        child: Scaffold(
                          key: _scaffold,
                          drawer: AppDrawer(),
                          body: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: (Theme.of(context).brightness ==
                                            Brightness.dark)
                                        ? AssetImage(
                                            'images/profile_screen_bg_dark.png')
                                        : AssetImage(
                                            'images/profile_screen_bg_light.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                // Container deals with triple dots row
                                margin: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.height * 0.02,
                                  right:
                                      MediaQuery.of(context).size.height * 0.02,
                                  top:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      child: Image.asset(
                                        'images/drawer_icon.png',
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      onTap: () {
                                        _scaffold.currentState!.openDrawer();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height *
                                          0.02),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                margin: EdgeInsets.fromLTRB(
                                    // main card where all stuffs are present
                                    MediaQuery.of(context).size.width * 0.09,
                                    MediaQuery.of(context).size.height * 0.12,
                                    MediaQuery.of(context).size.width * 0.09,
                                    MediaQuery.of(context).size.height * 0.022),
                              ),
                              Container(
                                // the profile picture containing container
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.16,
                                    top: MediaQuery.of(context).size.height *
                                        0.05),
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                decoration: ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.height *
                                          0.012),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.height *
                                            0.08),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.12,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.12,
                                      child: (profileUserData
                                                  .value.profilePicture ==
                                              null)
                                          ? Image.asset(
                                              'images/profile_picture.png',
                                              fit: BoxFit.fill,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: stringX +
                                                  profileUserData
                                                      .value.profilePicture!,
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    //container consisting of below dp data
                                    margin: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width * 0.15,
                                      MediaQuery.of(context).size.height * 0.22,
                                      MediaQuery.of(context).size.width * 0.15,
                                      MediaQuery.of(context).size.height * 0.01,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.36,
                                                child: Text(
                                                  profileUserData.value.name!,
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.045,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, EditProfile.id);
                                                },
                                                child: Text(
                                                  'Edit profile',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.045,
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.013,
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.045,
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.013),
                                                  primary: kBottomNavigationBar,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          child: (profileUserData.value.bio !=
                                                  "")
                                              ? Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.03,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.92,
                                                            child: Text(
                                                              profileUserData
                                                                  .value.bio!,
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.023,
                                                                fontFamily:
                                                                    'Montserrat',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : null,
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.035,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                TextButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    profileUserData.value.post!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.07,
                                                        ),
                                                  ),
                                                ),
                                                Text(
                                                  'Memes',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      FollowListScreen.id,
                                                    );
                                                  },
                                                  child: Text(
                                                    profileUserData
                                                        .value.followers!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.07,
                                                        ),
                                                  ),
                                                ),
                                                Text(
                                                  'Followers',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      FollowListScreen.id,
                                                    );
                                                  },
                                                  child: Text(
                                                    profileUserData
                                                        .value.following!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.07,
                                                        ),
                                                  ),
                                                ),
                                                Text(
                                                  'Following',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.09,
                                      right: MediaQuery.of(context).size.width *
                                          0.09,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xFFB3B0B0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.0008,
                                        ),
                                      ),
                                    ),
                                    child: TabBar(
                                      indicatorColor: kBottomNavigationBar,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      indicatorWeight: 3.5,
                                      labelColor: kBottomNavigationBar,
                                      labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      unselectedLabelColor: Color(0x660385A3),
                                      tabs: [
                                        Tab(text: 'Memes'),
                                        Tab(
                                          text: 'Saved',
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                          child: GridView.builder(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06),
                                              itemCount: posts.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 13,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                if (posts.length <= 5 &&
                                                    posts.length > -1) {
                                                  return Material(
                                                    elevation: 4,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(16),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(16),
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                            UserMemesScreen.id,
                                                          );
                                                        },
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: stringX +
                                                              posts[index],
                                                          fit: BoxFit.cover,
                                                          progressIndicatorBuilder:
                                                              (context, url,
                                                                      downloadProgress) =>
                                                                  SpinKitFadingCube(
                                                            color:
                                                                kPrimaryColor,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                } else if (posts.length > 5 &&
                                                    index < 5) {
                                                  return Material(
                                                    elevation: 4,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(16),
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                          UserMemesScreen.id,
                                                        );
                                                      },
                                                      child: CachedNetworkImage(
                                                        imageUrl: stringX +
                                                            posts[index],
                                                        fit: BoxFit.cover,
                                                        progressIndicatorBuilder:
                                                            (context, url,
                                                                    downloadProgress) =>
                                                                SpinKitFadingCube(
                                                          color: kPrimaryColor,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(16),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              UserMemesScreen
                                                                  .id);
                                                        },
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons.add,
                                                            size: 28,
                                                          ),
                                                          onPressed: () {
                                                            // TODO Show list of memes made by this profile
                                                          },
                                                        ),
                                                      ),
                                                      Text(
                                                        (posts.length - 5)
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 28),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                        Container(
                                            margin: EdgeInsets.fromLTRB(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.09,
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.09,
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                            child: SavedPosts()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                loading: (_) => Scaffold(body: Progress()),
                error: (_) => Container());
          })
        : NetworkErrorScreen();
  }
}
