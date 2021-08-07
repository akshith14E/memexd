import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/screens/post_screen.dart';
import 'package:memexd/screens/profile_screen.dart';
import 'package:memexd/screens/editor_screen.dart';
import 'package:memexd/screens/searched_user_profile.dart';
import 'package:memexd/screens/signin_screen.dart';
import 'package:memexd/screens/template_screen.dart';
import 'package:memexd/services/get_templates.dart';
import '../widgets/app_drawer.dart';
import 'package:memexd/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/screens/profile_screen.dart';
import 'package:memexd/screens/home_screen.dart';

import 'home_screen.dart';

class RootPage extends ConsumerWidget {
  static const String id = 'RootPage';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _auth = watch(authServicesProvider);

    return SafeArea(
      child: Scaffold(
        drawer: AppDrawer(),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Root Page Screen'),
              SizedBox(height: 50),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Home.id);
                },
                child: Text('Home'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, ProfileScreen.id);
                },
                child: Text('Profile Page'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, EditorScreen.id);
                },
                child: Text('Editor Screen'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, TemplateScreen.id);
                },
                child: Text('Template Screen'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SearchedProfile.id);
                },
                child: Text('Searched Profile'),
              ),
              TextButton(
                onPressed: () => _auth.signOut(),
                child: Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
