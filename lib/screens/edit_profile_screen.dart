import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/constants/stringX.dart';
import 'package:memexd/constants/text_style_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/providers/registrationScreen_providers.dart';
import 'package:memexd/controllers/registration_screen_controllers.dart';
import 'package:memexd/services/ad_helper.dart';
import 'package:memexd/services/image_services.dart';
import 'dart:io';
import 'package:memexd/services/image_upload.dart';
import 'package:memexd/widgets/LoaderDialog.dart';
import 'package:memexd/widgets/custom_app_bar.dart';
import 'package:memexd/widgets/progress_indicator.dart';

class EditProfile extends ConsumerWidget {
  static const String id = 'EditProfileScreen';
  static final firebaseRef = FirebaseAuth.instance.currentUser!;
  static String? emailUser = FirebaseAuth.instance.currentUser!.email;

  // static String? usernameInitialValue = emailUser!.split("@")[0];
  // static String bioInitialValue = 'Hey, there I am using MemeXD';
  String? username;
  String? initialUsername;
  String? bio;
  static String? _photourl = FirebaseAuth.instance.currentUser!.photoURL;
  static String? _displayName = FirebaseAuth.instance.currentUser!.displayName;
  static String? _email = FirebaseAuth.instance.currentUser!.email;
  String usernameValidator = "";
  String? imageURL;
  String? croppedImage;
  bool isChanged = false;
  String? urlImage;
  bool isUserCreated = false;

  final _formKey = GlobalKey<FormState>();
  GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', "https://www.googleapis.com/auth/userinfo.profile"]);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    InterstitialAdsWidget adObject = new InterstitialAdsWidget();
    adObject.createInterad();
    final usernameExists = watch(usernameExistsProvider);
    final isChecked = watch(isCheckedProvider);
    final imageFile = watch(croppedImageProvider);
    return Scaffold(
      appBar: customAppbar(context),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Edit Profile',
                  style: kEditProfileText,
                ),
              ),
              Center(
                child: Padding(
                  padding:
                      EdgeInsets.all(0.02 * MediaQuery.of(context).size.height),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                          height: 0.05 * MediaQuery.of(context).size.height),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            leading: GestureDetector(
                              child: ClipRRect(
                                child: isChanged
                                    ? Image(
                                        image:
                                            FileImage(File(imageFile.state!)),
                                        height: 0.1 *
                                            MediaQuery.of(context).size.height,
                                      )
                                    : FutureBuilder(
                                        future: FirebaseDatabase.instance
                                            .reference()
                                            .child('Users')
                                            .child(firebaseRef.uid)
                                            .child('imageUrl')
                                            .once(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          if (snapshot.hasData) {
                                            if (snapshot.data!.value != null) {
                                              return CachedNetworkImage(
                                                imageUrl: stringX +
                                                    snapshot.data.value,
                                                height: 0.1 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height,
                                              );
                                            } else
                                              return Image.network(_photourl!);
                                          } else
                                            return CircularProgressIndicator();
                                        }),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onLongPress: () async {
                                croppedImage =
                                    await imagePickCrop(ImageSource.gallery);
                                imageFile.state = croppedImage;
                                isChanged = true;
                              },
                            ),
                            title: Text(
                              _displayName!,
                            ),
                            subtitle: Text(_email!),
                          ),
                          TextButton(
                            onPressed: () async {
                              croppedImage =
                                  await imagePickCrop(ImageSource.gallery);
                              imageFile.state = croppedImage;
                              isChanged = true;
                            },
                            child: Text(
                              '   Change Photo',
                              style: TextStyle(
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //SizedBox(height: 0.03 * MediaQuery.of(context).size.height),
                      Container(
                        padding: EdgeInsets.only(
                          left: 0.015 * MediaQuery.of(context).size.height,
                          right: 0.015 * MediaQuery.of(context).size.height,
                        ),
                        child: Column(
                          children: [
                            FutureBuilder(
                                future: FirebaseDatabase.instance
                                    .reference()
                                    .child('Users')
                                    .child(firebaseRef.uid)
                                    .child('username')
                                    .once(),
                                builder:
                                    (context, AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.value != null) {
                                      if (username == null) {
                                        username = snapshot.data.value;
                                        initialUsername = snapshot.data.value;
                                      }
                                      return TextFormField(
                                        initialValue: snapshot.data.value,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[a-zA-Z0-9_]")),
                                        ],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                        decoration: InputDecoration(
                                          labelText: "Username",
                                          labelStyle: kTextFieldLabelText,
                                          //fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          username = value.toLowerCase();

                                          //print('$username');
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value.length < 4)
                                            return 'Username should be atleast 4 characters long';
                                          if (value.length <= 20) {
                                            if (usernameExists.state == true)
                                              return 'This username already exists';
                                            else
                                              return null;
                                          }
                                          if (value.length > 20)
                                            return "Shorten your username";
                                          return null;
                                        },
                                      );
                                    } else
                                      return Center(
                                          child: CircularProgressIndicator());
                                  } else
                                    return Center(
                                        child: CircularProgressIndicator());
                                }),
                            SizedBox(
                              height: 0.05 * MediaQuery.of(context).size.height,
                            ),
                            FutureBuilder(
                                future: FirebaseDatabase.instance
                                    .reference()
                                    .child('Users')
                                    .child(firebaseRef.uid)
                                    .child('bio')
                                    .once(),
                                builder:
                                    (context, AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.value != null) {
                                      if (bio == null)
                                        bio = snapshot.data.value;
                                      return TextFormField(
                                        initialValue: snapshot.data.value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                        decoration: InputDecoration(
                                          labelText: "Description",
                                          labelStyle: kTextFieldLabelText,
                                          //fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                        maxLines: 3,
                                        onChanged: (value) {
                                          bio = value;
                                        },
                                        validator: (value) {
                                          if (value!.length >= 69)
                                            return "Try to shorten your bio";
                                          return null;
                                        },
                                      );
                                    } else
                                      return Center(
                                          child: CircularProgressIndicator());
                                  } else
                                    return Center(
                                        child: CircularProgressIndicator());
                                }),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: 0.03 * MediaQuery.of(context).size.height),

                      ElevatedButton(
                        onPressed: () async {

                          var response = await checkUser(username!);
                          if (response && username != initialUsername) {
                            context.read(usernameExistsProvider).state = true;
                          } else {
                            context.read(usernameExistsProvider).state = false;
                          }

                          if (_formKey.currentState!.validate()) {
                            final GlobalKey _LoaderDialog = new GlobalKey();
                            LoaderDialog.showLoadingDialog(context, _LoaderDialog);
                            if (isChanged) {
                              imageURL = await uploadImageToFirebase(
                                  File(imageFile.state!));

                              urlImage = imageURL!.replaceAll(stringX, "");

                              print('url of final image :$imageURL');

                              await FirebaseDatabase.instance
                                  .reference()
                                  .child('Users')
                                  .child(firebaseRef.uid)
                                  .update({
                                'username': username,
                                'bio': bio,
                                'imageUrl': urlImage,
                              });
                            } else {
                              await FirebaseDatabase.instance
                                  .reference()
                                  .child('Users')
                                  .child(firebaseRef.uid)
                                  .update({
                                'username': username,
                                'bio': bio,
                              });
                            }
                            if(_LoaderDialog.currentContext!=null)
                              Navigator.of(_LoaderDialog.currentContext!,rootNavigator: true).pop();

                            isUserCreated = await checkUser(username!);
                            if (isUserCreated == false)
                              Progress();
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Your profile has been updated'),
                                ),
                              );
                              adObject.showInterad();
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.019,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: kSignInButtonColor2,
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.018,
                            top: MediaQuery.of(context).size.height * 0.018,
                            left: MediaQuery.of(context).size.height * 0.03,
                            right: MediaQuery.of(context).size.height * 0.03,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
