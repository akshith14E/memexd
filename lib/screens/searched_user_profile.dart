import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/providers/shared_preferences_provider.dart';
import 'package:memexd/screens/search_memers_screen.dart';
import 'package:memexd/screens/user_meme_screen.dart';
import 'package:memexd/widgets/app_drawer.dart';
import 'package:memexd/constants/stringX.dart';
import 'package:memexd/widgets/network_error_screen.dart';
import 'package:memexd/widgets/fading_cube.dart';
import 'package:memexd/widgets/progress_indicator.dart';

String status = 'Follow';

class User {
  int? following;
  String? name;
  int? followers;
  int? post;
  String? bio;
  String? profilePicture;

  User({
    this.followers,
    this.name,
    this.following,
    this.post,
    this.bio,
    this.profilePicture,
  });
}

List<String> posts = [];

class UserData extends StateNotifier<AsyncValue<User>> {
  UserData() : super(AsyncLoading());

  Future<void> getData(String id) async {
    state = AsyncLoading();
    await FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(id)
        .onValue
        .listen((event) async {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        state = AsyncData(
          User(
            followers: snapshot.value['tfrs'],
            name: snapshot.value['username'].toString(),
            bio: snapshot.value['bio'].toString(),
            following: snapshot.value['tflng'],
            post: snapshot.value['tpsts'],
            profilePicture: snapshot.value['imageUrl'],
          ),
        );
        await getPosts(id);
      } else {
        state = AsyncError(User());
      }
    });
  }

  Future<void> getPosts(String id) async {
    await FirebaseDatabase.instance
        .reference()
        .child('Posts')
        .limitToLast(6)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (values['publisher'] == id) posts.add(values['postImage']);
      });
    });
  }
}

final userDataNotifier =
    StateNotifierProvider<UserData, AsyncValue<User>>((ref) {
  return UserData();
});

checkFollowing(String userId) async {
  DataSnapshot snapshot = await FirebaseDatabase.instance
      .reference()
      .child('Follow')
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('following')
      .child(userId)
      .once();
  if (snapshot.value == null) {
    status = 'Follow';
  } else
    status = 'Following';
}

followUser(String userId) {
  if (status == 'Follow') {
    status = 'Following';
    addFollower(userId);
    addFollowing(userId);
    increaseNumberOfFollowers(userId);
    increaseNumberOfFollowing();
  } else {
    status = 'Follow';
    removeFollower(userId);
    removeFollowing(userId);
    decreaseNumberOfFollowers(userId);
    decreaseNumberOfFollowing();
  }
}

addFollower(String userId) {
  FirebaseDatabase.instance
      .reference()
      .child('Follow')
      .child(userId)
      .child('followers')
      .update({FirebaseAuth.instance.currentUser!.uid: true});
}

increaseNumberOfFollowers(String userId) {
  final dataRef = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(userId)
      .child('tfrs');
  dataRef.runTransaction((MutableData transaction) async {
    transaction.value = (transaction.value ?? 0) + 1;
    return transaction;
  });
}

increaseNumberOfFollowing() {
  final dataRef = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('tflng');
  dataRef.runTransaction((MutableData transaction) async {
    print(transaction.value);
    transaction.value = (transaction.value ?? 0) + 1;
    return transaction;
  });
}

decreaseNumberOfFollowers(String userId) {
  final dataRef = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(userId)
      .child('tfrs');
  dataRef.runTransaction((MutableData transaction) async {
    print(transaction.value);
    transaction.value = (transaction.value ?? 0) - 1;
    return transaction;
  });
}

decreaseNumberOfFollowing() {
  final dataRef = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('tflng');
  dataRef.runTransaction((MutableData transaction) async {
    print(transaction.value);
    transaction.value = (transaction.value ?? 0) - 1;
    return transaction;
  });
}

removeFollower(String userId) {
  FirebaseDatabase.instance
      .reference()
      .child('Follow')
      .child(userId)
      .child('followers')
      .child(FirebaseAuth.instance.currentUser!.uid)
      .remove();
}

addFollowing(String userId) {
  FirebaseDatabase.instance
      .reference()
      .child('Follow')
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('following')
      .update({userId: true});
}

removeFollowing(String userId) {
  FirebaseDatabase.instance
      .reference()
      .child('Follow')
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('following')
      .child(userId)
      .remove();
}

class SearchedProfile extends StatefulWidget {
  final String userId;

  static String get id => 'User_Screen';

  const SearchedProfile({Key? key, required this.userId}) : super(key: key);

  @override
  _SearchedProfileState createState() => _SearchedProfileState();
}

class _SearchedProfileState extends State<SearchedProfile> {
  GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  StreamSubscription? subscription;
  InternetConnectionStatus networkStatus = InternetConnectionStatus.connected;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      checkFollowing(widget.userId);
      print("eke");
      Future.wait(
          [context.read(userDataNotifier.notifier).getData(widget.userId)]);
    });
    subscription = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      networkStatus = status;
      print(status.toString());
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return networkStatus == InternetConnectionStatus.connected
        ? Consumer(
            builder: (context, watch, child) {
              final userData = watch(userDataNotifier);
              return userData.map(
                  data: (userData) => SafeArea(
                        child: DefaultTabController(
                          length: 1,
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
                                  // container dealing with back button row
                                  margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.height *
                                        0.02,
                                    top: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.chevron_left_outlined,
                                          color:
                                              Theme.of(context).backgroundColor,
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.03),
                                  child: Container(
                                    // conatainer deals with main card
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    margin: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width * 0.09,
                                      MediaQuery.of(context).size.height * 0.12,
                                      MediaQuery.of(context).size.width * 0.09,
                                      MediaQuery.of(context).size.height *
                                          0.022,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.16,
                                      top: MediaQuery.of(context).size.height *
                                          0.07),
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
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
                                        child: (userData.value.profilePicture ==
                                                null)
                                            ? Image.asset(
                                                'images/profile_picture.png',
                                                fit: BoxFit.fill,
                                              )
                                            : Image.network(
                                                stringX +
                                                    (userData.value
                                                            .profilePicture ??
                                                        ""),
                                                fit: BoxFit.fill,
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
                                        MediaQuery.of(context).size.width *
                                            0.15,
                                        MediaQuery.of(context).size.height *
                                            0.23,
                                        MediaQuery.of(context).size.width *
                                            0.15,
                                        MediaQuery.of(context).size.height *
                                            0.01,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                userData.value.name!,
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
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    followUser(widget.userId);
                                                  });
                                                },
                                                child: Text(
                                                  status,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.fromLTRB(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.017,
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.017),
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
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.92,
                                                  child: Text(
                                                    userData.value.bio ??
                                                        "hello",
                                                    overflow:
                                                        TextOverflow.visible,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.023,
                                                      fontFamily: 'Montserrat',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
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
                                                  Text(
                                                    userData.value.post!
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.07,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.017,
                                                  ),
                                                  Text(
                                                    'Memes',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.04),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    userData.value.followers!
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.07,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.017,
                                                  ),
                                                  Text(
                                                    'Followers',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.04),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    userData.value.following!
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.07,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.017,
                                                  ),
                                                  Text(
                                                    'Following',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: MediaQuery.of(
                                                                    context)
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
                                                0.020,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.09,
                                        right:
                                            MediaQuery.of(context).size.width *
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
                                        indicatorSize:
                                            TabBarIndicatorSize.label,
                                        indicatorWeight: 3.5,
                                        labelColor: kBottomNavigationBar,
                                        labelStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        unselectedLabelColor: Color(0x6638808F),
                                        tabs: [
                                          Tab(text: 'Memes'),
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
                                                    0.02,
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
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 13,
                                                crossAxisCount: 3,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(context,
                                                        UserMemesScreen.id);
                                                  },
                                                  child: Material(
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
                                                      child: Image.network(
                                                        stringX + posts[index],
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
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
                  loading: (_) => Scaffold(
                        body: Progress(),
                      ),
                  error: (_) => Container());
            },
          )
        : NetworkErrorScreen();
  }
}
