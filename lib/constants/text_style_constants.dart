import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:memexd/constants/color_constants.dart';

const kSigninText = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 19,
  fontFamily: 'Boston',
);

const kWelcomeText = TextStyle(
  color: Color(0xFF38808F),
  fontWeight: FontWeight.w500,
  fontSize: 19,
  fontFamily: 'Boston',
);
const kEditProfileText = TextStyle(
  color: Color(0xFF38808F),
  fontWeight: FontWeight.w500,
  fontSize: 23,
  fontFamily: 'Boston',
);

const kUsernameText = TextStyle(
  fontSize: 17,
  color: Colors.black,
  decoration: TextDecoration.none,
);

const kTextFieldLabelText = TextStyle(
  fontSize: 20,
  color: Colors.black,
  decoration: TextDecoration.none,
);

const kTimeStampText = TextStyle(
  fontSize: 10,
  color: Colors.black,
  decoration: TextDecoration.none,
);

const kCaptionText = TextStyle(
  fontSize: 13,
  color: Colors.grey,
  decoration: TextDecoration.none,
);

const kAppBarText = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  decoration: TextDecoration.none,
  letterSpacing: 5,
);

const kFeedBarText = TextStyle(
  fontSize: 17,
  color: Colors.black45,
  fontWeight: FontWeight.bold,
  decoration: TextDecoration.none,
);

const kSearchTemplates = TextStyle(
  fontSize: 12,
  color: Colors.black,
);

const kTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.zero,
  isDense: true,
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: kHintTextColor),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: kHintTextColor, width: 2.5),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: kHintTextColor),
  ),
);

const kSizedBox = SizedBox(
  height: 30,
);

const kHintTextStyle =
    TextStyle(fontSize: 17, color: kHintTextColor, fontFamily: 'Montserrat');

const kTextStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 17,
);

const kChangeProfilePicture = TextStyle(
  color: kSignInButtonColor2,
  fontFamily: 'Montserrat',
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

const kModalText = TextStyle(
    fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Montserrat');

const kProfilePage = TextStyle(fontSize: 15, fontFamily: 'Montserrat');
