import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String bannerAdId = Platform.isIOS
    ? dotenv.get("IOS_ADMOB_INTERSTITIAL_USER_STATUS")
    : dotenv.get("ANDROID_ADMOB_INTERSTITIAL_USER_STATUS");
String openAd = dotenv.get("IOS_ADMOB_OPEN");
String interstitialUserStatusAdId = Platform.isIOS
    ? dotenv.get("IOS_ADMOB_INTERSTITIAL_USER_STATUS")
    : dotenv.get("ANDROID_ADMOB_INTERSTITIAL_USER_STATUS");
String interstitialInsentiveSheeet = Platform.isIOS
    ? dotenv.get("IOS_ADMOB_INTERSTITIAL_USER_STATUS")
    : dotenv.get("ANDROID_ADMOB_INTERSTITIAL_USER_STATUS");

class AdmobLoad {
  int numOfAttemptLoad = 0;

  BannerAd createBannerAd() {
    return BannerAd(
        size: AdSize.banner,
        adUnitId: bannerAdId,
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
        adUnitId: interstitialUserStatusAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            showAd(ad);
            numOfAttemptLoad = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print(error);

            numOfAttemptLoad + 1;

            if (numOfAttemptLoad <= 2) {
              interstitialUserStatus();
            }
          },
        ));
  }

  void interstitialIncetiveSheeet() {
    InterstitialAd.load(
        adUnitId: interstitialInsentiveSheeet,
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
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  void loadAd() {
    AppOpenAd.load(
      adUnitId: openAd,
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
