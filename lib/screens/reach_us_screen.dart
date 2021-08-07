import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ReachUsScreen extends StatefulWidget {
  static const String id = 'ReachUsScreen';

  @override
  _ReachUsScreenState createState() => _ReachUsScreenState();
}

class _ReachUsScreenState extends State<ReachUsScreen> {
  final _bodyController = TextEditingController();
  final _subjectController = TextEditingController();

  Future<void> send() async {
    final Email email = Email(
      subject: _subjectController.text,
      recipients: ['Contact.memexd@gmail.com'],
      body: _bodyController.text,
    );

    String platformResponse;
    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  'Reach Us',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2!.color,
                    fontSize: 28,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Text(
                  'It\'s not you, it\'s not me either. it\'s US! We at Meme xD are always up for good conversations. From how much sugar to put in your coffee to any suggestions you may have for us,we\'re always hearing and responding.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat-Regular',
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
                TextFormField(
                  controller: _subjectController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Subject',
                    hintStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Theme.of(context).textTheme.bodyText2!.color,
                    ),
                    focusColor: Colors.black,
                    filled: true,
                    enabledBorder: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff38808F),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
                TextFormField(
                  controller: _bodyController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Explain your issue here...',
                    hintStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Theme.of(context).textTheme.bodyText2!.color,
                    ),
                    focusColor: Colors.black,
                    filled: true,
                    enabledBorder: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff38808F),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(60.0),
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff38808F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        onPressed: send,
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Montserrat',
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
