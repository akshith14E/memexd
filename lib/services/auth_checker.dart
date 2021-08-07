import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:memexd/main.dart';
import 'package:memexd/providers/auth_provider.dart';
import 'package:memexd/screens/editor_screen.dart';
import 'package:memexd/screens/home_screen.dart';
import 'package:memexd/screens/post_screen.dart';
import 'package:memexd/screens/registration_screen.dart';
import 'package:memexd/screens/signin_screen.dart';
import 'dart:developer' as developer;

import 'package:memexd/services/get_templates.dart';
import 'package:memexd/services/get_user_data.dart';
import 'package:memexd/services/network_checker.dart';
import 'package:memexd/widgets/network_error_screen.dart';

import 'package:memexd/widgets/progress_indicator.dart';

class AuthChecker extends ConsumerWidget {
  static const String id = 'Auth_checker';


  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _statusChecker = watch(networkResult);
    final _authState = watch(authStateProvider);
    return _statusChecker.when(data: (data) {
      if (data) {
        return _authState.when(
          data: (value) {
            developer.log('value', name: value.toString());
            print(value);
            if (value != null) {
              return FutureBuilder(
                  future: FirebaseDatabase.instance
                      .reference()
                      .child('Users')
                      .child(value.uid)
                      .child('username')
                      .once(),
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.value != null) {
                        GetTemplates getTemplates = GetTemplates();
                        getTemplates.getTemplates();

                        GetUserData getUserData = GetUserData();
                        getUserData.getUserData(value.uid, snapshot.data.value);
                        return Home();
                      } else
                        return RegistrationScreen();
                    } else if (snapshot.hasError) {
                      print('Error : $snapshot.hasError');
                      return Progress();
                    } else
                      return Progress();
                  });
            }
            return SigninScreen();
          },
          loading: () {
            return Scaffold(
              body: Progress(),
            );
          },
          error: (e, _s) {
            print(e);
            return Container();
          },
        );
      } else {
        return NetworkErrorScreen();
      }
    }, loading: () {
      print('loading');
      return Progress();
    }, error: (e, s) {
      //print(e);
      return Container();
    });
  }
}
