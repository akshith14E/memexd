import 'package:flutter/material.dart';
import 'package:memexd/widgets/progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_app_bar.dart';
import '../services/remote_config_service.dart';

class FollowUsScreen extends StatefulWidget {
  static String get id => 'Follow_Us_Screen';
  @override
  _FollowUsScreenState createState() => _FollowUsScreenState();
}

class _FollowUsScreenState extends State<FollowUsScreen> {
  bool _isLoading = true;
  late RemoteConfigService _remoteConfigService;
  initializeRemoteConfig() async {
    _remoteConfigService = await RemoteConfigService.getInstance();
    await _remoteConfigService.initialize();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    initializeRemoteConfig();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context),
      body: _isLoading
          ? Progress()
          : Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Text(
                      'Follow Us',
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
                      'What is the one thing common\nbetween God and memeXd? Both are\nomnipresent!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: 17,
                        fontFamily: 'Montserrat-Regular',
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Text(
                      'Follow us on various platforms:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SocialMediaHandles(
                      mediaName: 'Facebook',
                      assetName: 'facebook_icon',
                      url: _remoteConfigService.getStringValueF,
                    ),
                    SocialMediaHandles(
                      mediaName: 'Youtube',
                      assetName: 'youtube',
                      url: _remoteConfigService.getStringValueY,
                    ),
                    SocialMediaHandles(
                      mediaName: 'Instagram',
                      assetName: 'instagram',
                      url: _remoteConfigService.getStringValueI,
                    ),
                    SocialMediaHandles(
                      mediaName: 'Twitter',
                      assetName: 'twitter',
                      url: _remoteConfigService.getStringValueT,
                    ),
                    SocialMediaHandles(
                      mediaName: 'LinkedIn',
                      assetName: 'linkedin',
                      url: _remoteConfigService.getStringValueL,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Thank You!',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 26,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
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

class SocialMediaHandles extends StatelessWidget {
  final String? mediaName;
  final String? assetName;
  final String? url;
  SocialMediaHandles({
    this.mediaName,
    this.assetName,
    this.url,
  });

  Future<void> _launchURL() async => await canLaunch(url!)
      ? await launch(url!)
      : throw 'Could not launch $url';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Text(
            mediaName!,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText2!.color,
              fontSize: 23,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: IconButton(
            icon: Image.asset(
              'images/$assetName.png',
            ),
            onPressed: _launchURL,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.013,
        ),
      ],
    );
  }
}
