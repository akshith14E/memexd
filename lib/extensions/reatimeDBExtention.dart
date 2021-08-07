import 'package:firebase_database/firebase_database.dart';

extension RealtimeDB on FirebaseDatabase {
  DatabaseReference byChild(String child) {
    return FirebaseDatabase.instance.reference().child(child);
  }
}