import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/constants/text_style_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/providers/registrationScreen_providers.dart';
import 'package:memexd/controllers/registration_screen_controllers.dart';
import 'package:memexd/screens/home_screen.dart';
import 'package:memexd/services/image_services.dart';
import 'dart:io';
import 'package:memexd/services/create_user.dart';
import 'package:memexd/services/image_upload.dart';
import 'package:memexd/widgets/LoaderDialog.dart';
import 'package:memexd/widgets/progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationScreen extends ConsumerWidget {
  static const String id = 'Registration_Screen';
  static String? emailUser = FirebaseAuth.instance.currentUser!.email;
  static String? usernameInitialValue = emailUser!.split("@")[0];
  static String bioInitialValue = 'Hey, there I am using MemeXD';
  String? username = usernameInitialValue;
  String bio = bioInitialValue;
  static String? _photourl = FirebaseAuth.instance.currentUser!.photoURL;
  static String? _displayName = FirebaseAuth.instance.currentUser!.displayName;
  static String? _email = FirebaseAuth.instance.currentUser!.email;
  String usernameValidator = "";
  String? imageURL;
  String? croppedImage;
  bool isChanged = false;
  String? urlImage;
  bool isUserCreated = false;

  String X =
      "https://firebasestorage.googleapis.com/v0/b/meemee1.appspot.com/o/";

  final _formKey = GlobalKey<FormState>();
  GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', "https://www.googleapis.com/auth/userinfo.profile"]);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final usernameExists = watch(usernameExistsProvider);
    final isChecked = watch(isCheckedProvider);
    final imageFile = watch(croppedImageProvider);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:
                  EdgeInsets.all(0.02 * MediaQuery.of(context).size.height),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 55,
                  ),
                  Image(
                    image: AssetImage('images/memexdlogo.png'),
                    height: 0.15 * MediaQuery.of(context).size.height,
                    width: 0.15 * MediaQuery.of(context).size.height,
                  ),
                  Text(
                    'Welcome to MemeXD',
                    style: kWelcomeText,
                  ),
                  SizedBox(height: 0.05 * MediaQuery.of(context).size.height),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        leading: GestureDetector(
                          child: ClipRRect(
                            child: isChanged
                                ? Image(
                                    image: FileImage(File(imageFile.state!)),
                                    height: 0.1 *
                                        MediaQuery.of(context).size.height,
                                  )
                                : Image(
                                    image: NetworkImage(_photourl!),
                                    height: 0.1 *
                                        MediaQuery.of(context).size.height,
                                  ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onLongPress: () async {
                            croppedImage =
                                await imagePickCrop(ImageSource.gallery);
                            imageFile.state = croppedImage;
                            isChanged = true;
                          },
                        ),
                        title: Text(_displayName!),
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
                        TextFormField(
                          initialValue: usernameInitialValue,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2!.color,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9_]")),
                          ],
                          decoration: InputDecoration(
                            labelText: "Username",
                            labelStyle: TextStyle(
                              fontSize: 20,
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(),
                            ),
                          ),
                          onChanged: (value) {
                            username = value.toLowerCase();
                            //print('$username');
                          },
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4)
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
                        ),
                        SizedBox(
                          height: 0.05 * MediaQuery.of(context).size.height,
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2!.color,
                          ),
                          initialValue: bioInitialValue,
                          decoration: InputDecoration(
                            labelText: "Description",
                            labelStyle: TextStyle(
                              fontSize: 20,
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0.03 * MediaQuery.of(context).size.height),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: isChecked.state,
                        activeColor: kSignInButtonColor2,
                        onChanged: (newValue) async {
                          isChecked.state = newValue!;
                        },
                      ),
                      Text('I, agree to'),
                      TextButton(
                        onPressed: () {
                          launch('https://www.memexd.in/TnC_app.pdf');
                        },
                        child: Text('tncs'),
                      ),
                      Text('&'),
                      TextButton(
                        onPressed: () {
                          launch('https://www.memexd.in/Privacy_Policy.pdf');
                        },
                        child: Text('Privacy Policy'),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {

                      var response = await checkUser(username!);
                      if (response) {
                        context.read(usernameExistsProvider).state = true;
                      } else {
                        context.read(usernameExistsProvider).state = false;
                      }
                      if (isChecked.state == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Please check the Privacy Policy and TnC box'),
                          ),
                        );
                      }
                      if (_formKey.currentState!.validate() &&
                          isChecked.state == true) {
                        final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();
                        LoaderDialog.showLoadingDialog(context, _LoaderDialog);

                        if (isChanged) {
                          imageURL = await uploadImageToFirebase(
                              File(imageFile.state!));
                        } else {
                          imageURL = await uploadImageFromUrl(_photourl!);
                        }

                        urlImage = imageURL!.replaceAll(
                            "https://firebasestorage.googleapis.com/v0/b/memexd-61ae8.appspot.com/o/",
                            "");
                        print('url of final image :$urlImage');

                        await CreateUser(
                                id: FirebaseAuth.instance.currentUser!.uid,
                                username: username,
                                bio: bio,
                                imageURL: urlImage)
                            .pushDetails();
                        if(_LoaderDialog.currentContext!=null)
                          Navigator.of(_LoaderDialog.currentContext!,rootNavigator: true).pop();

                        isUserCreated = await checkUser(username!);
                        if (isUserCreated == false)
                          Progress();
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Voila! Finally a worthy member'),
                            ),
                          );
                          Navigator.pushReplacementNamed(context, Home.id);
                        }
                      }
                    },
                    child: Text('Let me inn!'),
                    style: ElevatedButton.styleFrom(
                      primary: kSignInButtonColor2,
                      padding: EdgeInsets.only(
                        bottom: 10,
                        top: 10,
                        left: 25,
                        right: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
