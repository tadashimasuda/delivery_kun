import 'package:flutter/material.dart';
import 'package:nend_plugin/nend_plugin.dart';

int spotId = 3174;
String apiKey = "c5cb8bc474345961c6e7a9778c947957ed8e1e4f";

class NendBanner extends StatefulWidget {
  const NendBanner({Key? key}) : super(key: key);

  @override
  _NendBannerState createState() => _NendBannerState();
}

class _NendBannerState extends State<NendBanner> {
  late BannerAdController adController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: BannerAd(
          bannerSize: BannerSize.type320x50,
          listener: _eventListener(),
          onCreated: (controller) {
          adController = controller;
          adController.load(spotId: 3174, apiKey: "c5cb8bc474345961c6e7a9778c947957ed8e1e4f");
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
