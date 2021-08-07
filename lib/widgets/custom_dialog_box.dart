import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:memexd/constants/color_constants.dart';

class CustomDialogBox extends StatelessWidget {
  static String id = 'Custom_Dialog_Box';

  String? title;
  String? contentText;
  String? action1Text;
  String? action2Text;
  final Function()? action1onPressed;
  final Function()? action2onPressed;

  CustomDialogBox({
    this.title,
    this.action1Text,
    this.action2Text,
    this.contentText,
    this.action1onPressed()?,
    this.action2onPressed()?,
  });

  @override
  Widget build(BuildContext context) {
    double padding = MediaQuery.of(context).size.height * 0.04;
    double avatarRadius = MediaQuery.of(context).size.height * 0.06;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, title, contentText, action1Text, action2Text,
          action1onPressed, action2onPressed, padding, avatarRadius),
    );
  }
}

contentBox(context, title, contentText, action1Text, action2Text,
    action1onPressed, action2onPressed, padding, avatarRadius) {
  return Stack(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(
            left: padding,
            top: avatarRadius + padding * 0.5,
            right: padding,
            bottom: padding),
        margin: EdgeInsets.only(top: avatarRadius),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(padding),
            border: Border.all(color: kPrimaryColor)
            // boxShadow: [
            //   BoxShadow(
            //       color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
            // ],
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.020,
            ),
            Text(
              contentText,
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => action1onPressed(),
                  child: Text(
                    action1Text,
                    style: TextStyle(fontSize: 18, color: kPrimaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () => action2onPressed(),
                  child: Text(
                    action2Text,
                    style: TextStyle(fontSize: 18, color: kPrimaryColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ), // bottom part
      Positioned(
        left: padding,
        right: padding,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: avatarRadius,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
              child: Image.asset("images/memexdlogo.png")),
        ),
      ), // top part
    ],
  );
}

// class Constants {
//   Constants._();
//   static const double padding = 20;
//   static const double avatarRadius = 45;
// }
