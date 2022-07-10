import 'dart:io' show Platform;

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobLoad {
  BannerAd createBannerAd() {
    return BannerAd(
        size: AdSize.banner,
        // adUnitId: Platform.isIOS
        //     ? 'ca-app-pub-8624775791237653/7710222023'
        //     : 'ca-app-pub-8624775791237653/4702574836',
        adUnitId: Platform.isIOS
            ? "ca-app-pub-3940256099942544/2934735716"
            : "ca-app-pub-3940256099942544/6300978111", //test
        listener: BannerAdListener(
            onAdLoaded: (ad) {},
            onAdFailedToLoad: (ad, error) {
              print(error);
            }),
        request: AdRequest())
      ..load();
  }
}