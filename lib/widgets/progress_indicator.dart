import 'package:flutter/material.dart';

class Progress extends StatefulWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'images/gifloading.gif',
        height: MediaQuery.of(context).size.height * 0.2,
      ),
    );
  }
}
