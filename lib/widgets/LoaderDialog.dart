import 'package:flutter/material.dart';

class LoaderDialog {

  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    var wid = MediaQuery.of(context).size.width / 2;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(left: 130 , right: 130),
          child: Dialog(
              key: key,
              backgroundColor: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.height * 0.2,
                child:  Image.asset(
                  'images/gifloading.gif',
                  height: 60,
                  width: 60,
                ),
              )
          ),
        );
      },
    );
  }
}