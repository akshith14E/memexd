import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';


const String _youtube_url = "youtube";
const String _twitter_url = "twitter";
const String _linkedin_url = "linkedin";
const String _instagram_url = "instagram";
const String _facebook_url = "facebook";

class RemoteConfigService {
  final RemoteConfig _remoteConfig;
  RemoteConfigService({RemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig!;
  final defaults = <String, dynamic>{
    _youtube_url:
        "https://www.youtube.com/channel/UCIcGF9iyOFglTH4VZf51LtQ?view_as=subscriber",
    _twitter_url: "https://twitter.com/Meme__xD",
    _linkedin_url: "https://www.linkedin.com/company/memexd",
    _instagram_url: "https://www.instagram.com/xd.memexd/",
    _facebook_url: "https://www.facebook.com/MemexD-106255747869134",
  };

  static RemoteConfigService? _instance;
  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance = RemoteConfigService(
        remoteConfig: RemoteConfig.instance,
      );
    }
    return _instance!;
  }

  String get getStringValueY => _remoteConfig.getString(_youtube_url);
  String get getStringValueT => _remoteConfig.getString(_twitter_url);
  String get getStringValueL => _remoteConfig.getString(_linkedin_url);
  String get getStringValueI => _remoteConfig.getString(_instagram_url);
  String get getStringValueF => _remoteConfig.getString(_facebook_url);

  Future initialize() async {
    try {
      await _remoteConfig.setDefaults(defaults);
      await _fetchAndActivate();
    } on PlatformException catch (e) {
      print("Remote Config fetch throttled: $e");
    } catch (e) {
      print('Unable to fetch remote config. Default value will be used');
    }
  }

  Future _fetchAndActivate() async {
    await _remoteConfig.fetch();
    await _remoteConfig.activate();
    print("youtube::: $getStringValueY");
    print("twitter::: $getStringValueT");
    print("linkedin::: $getStringValueL");
    print("instagram::: $getStringValueI");
    print("facebook::: $getStringValueF");
  }
}
