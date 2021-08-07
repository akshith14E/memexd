import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/constants/text_style_constants.dart';
import 'package:memexd/providers/auth_provider.dart';
import 'package:memexd/screens/searched_user_profile.dart';

class SigninScreen extends ConsumerWidget {
  static const String id = 'Sign_In';
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _auth = watch(authServicesProvider);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(55),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image(
                image: AssetImage('images/memexdlogo.png'),
                height: 220,
                width: 220,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: kSignInButtonColor2,
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(MediaQuery.of(context).size.height * 0.01),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                          child: Image.asset('images/google_logo.png'),
                        ),
                        decoration: BoxDecoration(
                          color: kSignInButtonColor1,
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(MediaQuery.of(context).size.height * 0.01),
                            bottomLeft: Radius.circular(MediaQuery.of(context).size.height * 0.01),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: MaterialButton(
                          elevation: 10,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            _auth.signInWithGoogle();
                          },
                          child: Text(
                            'Sign In',
                            style: kSigninText,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: kSignInButtonColor2,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(MediaQuery.of(context).size.height * 0.01),
                            bottomRight: Radius.circular(MediaQuery.of(context).size.height * 0.01),
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
