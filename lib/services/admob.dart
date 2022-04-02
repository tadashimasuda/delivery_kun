import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobLoad {
  BannerAd createBarnnerAd(){
    return BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-3940256099942544/2934735716',
        listener: BannerAdListener(
            onAdLoaded: (ad){},
            onAdFailedToLoad: (ad,error){
              print(error);
            }
        ),
        request: AdRequest()
    )..load();
  }
}