import 'package:flutter/material.dart';
import 'package:memexd/widgets/custom_app_bar.dart';

class AboutUsScreen extends StatelessWidget {
  static String get id => 'About_Us_Screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                margin: EdgeInsets.all(8),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText2!.color,
                        fontWeight: FontWeight.w300,
                        wordSpacing: 2,
                        fontSize: 18),
                    children: [
                      TextSpan(
                        text: 'About Us\n\n',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextSpan(
                          text:
                              """Do you like scrolling through memes in your free time? Do you too feel like your friends don't understand the referencces you drop in normal conversions? Or are you simply tired of coming across "short videos" occupying half your screen, when you just want to see dank memes?\n\n\n"""),
                      TextSpan(
                          text:
                              """If you relate to any of these, MemeXD is the app you're looking for. Made by a small team of meme-enthusiasts, MemeXD promises to be the one-step solution to all your meme-ing requirements.\n\n\n"""),
                      TextSpan(
                          text:
                              """How, you ask? Filled with the lastest meme templates and a community who is on top of their meme game, this app is a social media targeted specifically at memes. Make your own memes, comment on someone else's meme, keep laughing at 1AM, the choices are endless\n\n\n"""),
                      TextSpan(
                          text:
                              """Find a vast selection of Indian meme templates and combined with an easy-to-use editor, trust us, MemeXD is the ultimate meme-ing app you have been looking for. And the best part about all of this? The team will regularly bring such cool new features based on community suggestions. Keep meme-ing, y'all!\n\n"""),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Thank You!',
                  style: TextStyle(
                    color: Color(0xff38808F),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
