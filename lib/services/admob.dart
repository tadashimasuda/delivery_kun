import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobLoad {
  int numOfAttemptLoad = 0;

  BannerAd createBannerAd() {
    return BannerAd(
        size: AdSize.banner,
        adUnitId: Platform.isIOS
            ? 'ca-app-pub-8624775791237653/7710222023'
            : 'ca-app-pub-8624775791237653/4702574836',
        // adUnitId: Platform.isIOS
        //     ? "ca-app-pub-3940256099942544/2934735716"
        //     : "ca-app-pub-3940256099942544/6300978111", //test
        listener: BannerAdListener(
            onAdLoaded: (ad) {},
            onAdFailedToLoad: (ad, error) {
              // print(error);
            }),
        request: const AdRequest())
      ..load();
  }

  void interstitialUserStatus() {
    InterstitialAd.load(
        adUnitId: Platform.isIOS
            ? 'ca-app-pub-8624775791237653/6141994994'
            : 'ca-app-pub-8624775791237653/8846412908',
        // adUnitId: Platform.isIOS
        //     ? 'ca-app-pub-3940256099942544/4411468910'
        //     : 'ca-app-pub-3940256099942544/1033173712', //test
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            showAd(ad);
            numOfAttemptLoad = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // print(error);

            numOfAttemptLoad + 1;

            if (numOfAttemptLoad <= 2) {
              interstitialUserStatus();
            }
          },
        ));
  }

  void interstitialIncetiveSheeet() {
    InterstitialAd.load(
        adUnitId: Platform.isIOS
            ? 'ca-app-pub-8624775791237653/3889599692'
            : 'ca-app-pub-8624775791237653/2289028823',
        // adUnitId: Platform.isIOS
        //     ? 'ca-app-pub-3940256099942544/4411468910'
        //     : 'ca-app-pub-3940256099942544/1033173712', //test
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            showAd(ad);
            numOfAttemptLoad = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // print(error);

            numOfAttemptLoad + 1;

            if (numOfAttemptLoad <= 2) {
              interstitialUserStatus();
            }
          },
        ));
  }

  void showAd(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print('onAdShowedFullScreenContent');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('onAdDismissedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError adError) {
        // print(adError);
        ad.dispose();
        interstitialUserStatus();
      },
    );

    ad.show();
  }
}

class AppOpenAdManager {
  String adUnitId = 'ca-app-pub-8624775791237653/2681201404'; //release
  // String adUnitId = 'ca-app-pub-3940256099942544/5662855259'; //test

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  void loadAd() {
    AppOpenAd.load(
      adUnitId: adUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowingAd = true;
              print('$ad onAdShowedFullScreenContent');
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('$ad onAdFailedToShowFullScreenContent: $error');
              _isShowingAd = false;
              ad.dispose();
              _appOpenAd = null;
            },
            onAdDismissedFullScreenContent: (ad) {
              if (Platform.isIOS) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: SystemUiOverlay.values);
              }
              print('$ad onAdDismissedFullScreenContent');
              _isShowingAd = false;
              ad.dispose();
              _appOpenAd = null;
            },
          );
          _appOpenAd!.show();
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
        },
      ),
    );
  }
}
