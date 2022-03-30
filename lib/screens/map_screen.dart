import 'package:delivery_kun/components/notLogin_drawer.dart';
import 'package:delivery_kun/services/admob.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:delivery_kun/components/login_drawer.dart';
import 'package:delivery_kun/components/map_screen_bottom_btn.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

Completer<GoogleMapController> _controller = Completer();

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  static void currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    final hasPermission = await handlePermission();

    if (!hasPermission) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.4746,
      ),
    ));
  }

  static Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // do stuff
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // do stuff
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // do stuff

      return false;
    }
    return true;
  }

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _initialPosition;
  late bool _loading;
  late BannerAd _bannerAd;
  bool _isAdLoaded = true;

  void _getUserLocation() async {
    final hasPermission = await MapScreen.handlePermission();

    if (!hasPermission) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _loading = false;
    });
  }

  _initBannerAd() {
    AdmobLoad admobLoad = AdmobLoad();
    _bannerAd = admobLoad.createBarnnerAd();
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    _getUserLocation();
    readToken();
    _initBannerAd();
  }

  final storage = new FlutterSecureStorage();

  Future<String?> readToken() async {
    String? token = await storage.read(key: 'token');
    if (token != null) {
      Provider.of<Auth>(context, listen: false).tryToken(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: Consumer<Auth>(builder: (context, auth, child) {
          return auth.authenticated ? LoginDrawer() : NotLoginDrawer();
        }),
      ),
      backgroundColor: Colors.grey.shade200,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: Builder(
          builder: (context) =>
              FloatingActionButton(
                elevation: 20,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(70),
                      image: DecorationImage(
                          image: AssetImage("images/user.png")),
                    )),
              ),
        ),
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : Container(
          child: Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                // markers: _createMarker(),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                buildingsEnabled: true,
                onTap: (LatLng latLang) {
                  print('Clicked: $latLang');
                },
              ),
              const Positioned(
                child: MapScreenBottomBtn(),
                bottom: 20
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isAdLoaded ? Container(
        height: _bannerAd.size.height.toDouble(),
        width: _bannerAd.size.width.toDouble(),
        child: AdWidget(ad: _bannerAd),
      ) : SizedBox(),
    );
  }
}
