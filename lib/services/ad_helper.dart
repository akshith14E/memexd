import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else
      throw new UnsupportedError("Unsupported platform");
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else
      throw new UnsupportedError("Unsupported platform");
  }

  static String get nativeAdUnitID {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110';
    } else
      throw new UnsupportedError("Unsupported platform");
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else
      throw new UnsupportedError("Unsupported platform");
  }
}

//Banner Ads
class BannerAdsWidget extends StatefulWidget {
  double? height;
  AdSize? adSize;
  double? width;

  BannerAdsWidget({this.height, this.adSize, this.width});

  @override
  _BannerAdsWidgetState createState() => _BannerAdsWidgetState();
}

class _BannerAdsWidgetState extends State<BannerAdsWidget> {
  static bool showAd = true;

  static BannerAd getBannerAd([AdSize? adSize]) {
    BannerAd banner = new BannerAd(
        size: adSize ?? AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (Ad ad) {
          print('ad loaded');
        }, onAdClosed: (Ad ad) {
          print('ad closed');
        }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
          showAd = false;
          ad.dispose();
        }, onAdOpened: (Ad ad) {
          print('ad opened');
        }),
        request: AdRequest());
    return banner;
  }

  _BannerAdsWidgetState();

  @override
  Widget build(BuildContext context) {
    BannerAd myBanner = getBannerAd(widget.adSize);
    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);

    return showAd
        ? Container(
            alignment: Alignment.center,
            child: adWidget,
            width: widget.width ?? myBanner.size.width.toDouble(),
            height: widget.height ?? myBanner.size.height.toDouble(),
          )
        : Container();
  }
}

//Interstitial Ads

class InterstitialAdsWidget {
  InterstitialAd? _interstitialAd;
  int num_of_attempt_load = 0;

  void createInterad() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback:
          InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
        _interstitialAd = ad;
        num_of_attempt_load = 0;
      }, onAdFailedToLoad: (LoadAdError error) {
        num_of_attempt_load += 1;
        _interstitialAd = null;
        if (num_of_attempt_load <= 2) {
          createInterad();
        }
      }),
    );
  }

// show interstitial ads to user
  void showInterad() {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
      print("ad onAdshowedFullscreen");
    }, onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print("ad Disposed");
      ad.dispose();
    }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror) {
      print('$ad OnAdFailed $aderror');
      ad.dispose();
      createInterad();
    });
    _interstitialAd!.show();
    _interstitialAd = null;
    print('ad Shown');
  }
}

// native ads
//
// class NativeAdsWidget extends StatefulWidget {
//   const NativeAdsWidget({Key? key}) : super(key: key);
//
//   @override
//   _NativeAdsWidgetState createState() => _NativeAdsWidgetState();
// }
//
// class _NativeAdsWidgetState extends State<NativeAdsWidget> {
//   bool showAd = true;
//
//   @override
//   static NativeAd getNativeAd() {
//     NativeAd native = new NativeAd.fromAdManagerRequest(
//       factoryId: 'listTile',
//       adUnitId: AdHelper.nativeAdUnitID,
//       listener: NativeAdListener(),
//       adManagerRequest: AdManagerAdRequest(),
//     );
//     return native;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     NativeAd myNative = getNativeAd();
//     myNative.load();
//     final AdWidget adWidget = AdWidget(ad: myNative);
//     return showAd
//         ? Container(
//             alignment: Alignment.center,
//             child: adWidget,
//             width: MediaQuery.of(context).size.width * 0.99,
//             height: MediaQuery.of(context).size.width * 0.99,
//           )
//         : Container();
//   }
// }

class RewardedAds{

  RewardedAd? rewardedAd;

  loadRewardedAd(){
    RewardedAd.load(adUnitId: AdHelper.rewardedAdUnitId,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad){
              this.rewardedAd = ad;
            },
            onAdFailedToLoad: (LoadAdError error){
            }
        )
    );
  }
  showRewardedAd(){
     rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem points){
      print('Rewarded with $points points');
    });
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad){print('ad showed');},
      onAdDismissedFullScreenContent: (RewardedAd ad){print('ad dismissed');ad.dispose();},
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError e){ad.dispose();},
      onAdWillDismissFullScreenContent: (RewardedAd ad){print('ad will Dismiss');}
    );
  }

}