import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memexd/services/auth_services.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

//to get authentication services object
final authServicesProvider = Provider<AuthenticationService>((ref) {
  return AuthenticationService(ref.read(firebaseAuthProvider));
});

// stream provider, whether the user is login/logout
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServicesProvider).authStateChange;
});

//realtime database provider
final firebaseDBProvider =
    Provider<FirebaseDatabase>((ref) => FirebaseDatabase.instance);
