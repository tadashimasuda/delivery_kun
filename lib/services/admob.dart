import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobLoad {
  BannerAd createBarnnerAd(){
    return BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-8624775791237653/7710222023',
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