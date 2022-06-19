import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

class AdmobLoad {
  // BannerAd createBarnnerAd(){
  //   return BannerAd(
  //       size: AdSize.banner,
  //       adUnitId: Platform.isIOS ? 'ca-app-pub-8624775791237653/7710222023'
  //           : 'ca-app-pub-8624775791237653/4702574836',
  //       listener: BannerAdListener(
  //           onAdLoaded: (ad){},
  //           onAdFailedToLoad: (ad,error){
  //             print(error);
  //           }
  //       ),
  //       request: AdRequest()
  //   )..load();
  // }
  bool createBarnnerAd(){
    return false;
  }
}