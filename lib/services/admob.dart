import 'dart:io' show Platform;

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobLoad {
  int num_of_attempt_load = 0;

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
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            showAd(ad);
            num_of_attempt_load = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // print(error);

            num_of_attempt_load + 1;

            if (num_of_attempt_load <= 2) {
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
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            showAd(ad);
            num_of_attempt_load = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // print(error);

            num_of_attempt_load + 1;

            if (num_of_attempt_load <= 2) {
              interstitialUserStatus();
            }
          },
        ));
  }

  void showAd(InterstitialAd ad) {
    if (ad != null) {
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          print('onAdShowedFullScreenContent');
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print('onAdDismissedFullScreenContent');
        },
        onAdFailedToShowFullScreenContent:
            (InterstitialAd ad, AdError adError) {
          // print(adError);
          ad.dispose();
          interstitialUserStatus();
        },
      );

      ad.show();
    }
  }
}
