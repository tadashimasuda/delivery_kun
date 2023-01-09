import 'package:delivery_kun/services/nend.dart';
import 'package:delivery_kun/services/admob.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as Admob;
import 'package:nend_plugin/nend_plugin.dart' as Nend;

class AdBanner extends StatefulWidget {
  const AdBanner({Key? key}) : super(key: key);

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  late Admob.BannerAd _bannerAdmob;
  late Nend.BannerAd _bannerNend;

  void _initBannerAd() {
    AdmobLoad admobLoad = AdmobLoad();
    NendLoad nendLoad = NendLoad();
    _bannerAdmob = admobLoad.createBannerAd();
    _bannerNend = nendLoad.createBannerAd();
  }

  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 52,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Admob.AdWidget(ad: _bannerAdmob),
          // child: Platform.isIOS
          //     ? _bannerNend
          //     : Admob.AdWidget(ad: _bannerAdmob)),
        ));
  }
}
