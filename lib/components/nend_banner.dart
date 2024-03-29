import 'package:flutter/material.dart';
import 'package:nend_plugin/nend_plugin.dart';
import 'package:flutter_config/flutter_config.dart';
import 'dart:io' show Platform;

int spotId =
    Platform.isIOS ? int.parse(FlutterConfig.get('IOS_NEND_SPOT_ID')) : 1060754;
String apiKey = Platform.isIOS
    ? FlutterConfig.get('IOS_NEND_API_KEY')
    : '4c0990fa8b90c0494b6443278c089f0aebf6a808';

// int spotId = 3172;
// String apiKey = 'a6eca9dd074372c898dd1df549301f277c53f2b9';

class NendBanner extends StatefulWidget {
  const NendBanner({Key? key}) : super(key: key);

  @override
  _NendBannerState createState() => _NendBannerState();
}

class _NendBannerState extends State<NendBanner> {
  late BannerAdController adController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: BannerAd(
          bannerSize: BannerSize.type320x50,
          listener: _eventListener(),
          onCreated: (controller) {
            adController = controller;
            adController.load(spotId: spotId, apiKey: apiKey);
            adController.show();
          },
        ),
      ),
    );
  }

  BannerAdListener _eventListener() {
    return BannerAdListener(
      onLoaded: () => print('onLoaded'),
      onReceiveAd: () => print('onReceived'),
      onFailedToLoad: () => print('onFailedToLoad'),
      onAdClicked: () => print('onAdClicked'),
      onInformationClicked: () => print('onInformationClicked'),
    );
  }
}
