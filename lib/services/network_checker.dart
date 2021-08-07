import 'dart:async';
import 'package:riverpod/riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final networkResult = StreamProvider<bool>((_) async* {
  bool status = await NetworkChecker().checkNetwork();
  yield status;
});

class NetworkChecker {
  checkNetwork() async {
    InternetConnectionChecker().checkInterval = Duration(seconds: 2);
    bool? result = await InternetConnectionChecker().hasConnection;

    //await Future.delayed(Duration(seconds: 5));
    print('result returned $result');
    return result;
  }
}
