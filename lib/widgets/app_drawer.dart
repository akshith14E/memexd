import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memexd/controllers/theme_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/providers/shared_preferences_provider.dart';
import 'package:memexd/screens/about_us_screen.dart';
import 'package:memexd/screens/follow_us_screen.dart';
import 'package:memexd/screens/post_screen.dart';
import 'package:memexd/screens/reach_us_screen.dart';
import 'package:memexd/screens/search_memers_screen.dart';
import 'package:memexd/services/auth_checker.dart';
import 'package:memexd/services/auth_services.dart';
import 'package:memexd/widgets/custom_dialog_box.dart';
import 'package:memexd/providers/auth_provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late bool _switchValue;
  FirebaseAuth? _firebaseAuth;

  @override
  void initState() {
    final _prefs = context.read(sharedPrefsProvider);
    final value = _prefs!.getBool('lightTheme');
    _switchValue = !(value == null ? true : value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        elevation: 0,
        child: Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                child: DrawerHeader(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.height * 0.028,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: Container(
                    margin: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.015,
                    ),
                    child: Text(
                      'Options',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText2!.color,
                        fontSize: 26,
                        letterSpacing: 1,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Dark Mode',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText2!.color,
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: Switch(
                        activeColor: Colors.white30,
                        inactiveThumbColor: Colors.black,
                        value: _switchValue,
                        onChanged: (value) {
                          setState(() {
                            _switchValue = value;
                            context.read(themeControllerProvider.notifier)
                              ..toggleTheme();
                          });
                        },
                      ),
                    ),
                    Menu(
                      navName: 'Search Memers',
                      navigator: SearchMemersScreen.id,
                    ),
                    Menu(
                      navName: 'About Us',
                      navigator: AboutUsScreen.id,
                    ),
                    Menu(
                      navName: 'Follow Us',
                      navigator: FollowUsScreen.id,
                    ),
                    Menu(
                      navName: 'Reach Us',
                      navigator: ReachUsScreen.id,
                    ),
                    ListTile(
                      title: Text(
                        'Sign Out',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 18,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => CustomDialogBox(
                            title: 'Sign Out ?',
                            contentText: '',
                            action1Text: 'Yes',
                            action2Text: 'No',
                            action1onPressed: ()  {
                                Navigator.of(context).pop();
                                AuthenticationService(FirebaseAuth.instance).signOut();
                            },
                            action2onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  final String? navName;
  final String? navigator;

  Menu({
    this.navName,
    this.navigator,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        navName!,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.normal,
            ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(navigator!);
      },
    );
  }
}
