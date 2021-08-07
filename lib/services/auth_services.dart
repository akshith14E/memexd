import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:memexd/screens/root_page.dart';
import 'package:flutter/material.dart';
import 'package:memexd/screens/registration_screen.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  // getting the current state of user
  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();
  //Stream<User> get authTokenChange => _firebaseAuth.idTokenChanges();

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await (GoogleSignIn().signIn());

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    ) as GoogleAuthCredential;
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }

  User? getCurrentUser() => _firebaseAuth.currentUser;
}
