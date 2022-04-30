import 'dart:async';
import 'package:delivery_kun/models/user_status.dart';
import 'package:delivery_kun/screens/user_status_screen.dart';
import 'package:delivery_kun/services/order.dart';
import 'package:delivery_kun/services/user_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:delivery_kun/services/admob.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:delivery_kun/services/direction.dart';
import 'package:delivery_kun/components/notLogin_drawer.dart';
import 'package:delivery_kun/components/login_drawer.dart';
import 'package:delivery_kun/components/map_screen_bottom_btn.dart';

Completer<GoogleMapController> _controller = Completer();

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  static Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
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
  late bool isAuthenticated;
  bool _isAdLoaded = true;
  Map<PolylineId, Polyline> polylines = {};

  void _getUserLocation() async {
    final hasPermission = await MapScreen.handlePermission();

    if (!hasPermission) {
      return;
    }

    LatLng locaiton= await _getCurrentLocation();
    setState(() {
      _initialPosition = LatLng(locaiton.latitude, locaiton.longitude);
      _loading = false;
    });
  }

  void _currentLocation() async{
    LatLng locaiton= await _getCurrentLocation();
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(locaiton.latitude, locaiton.longitude), 14.4746));
  }

  Future<LatLng> _getCurrentLocation() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }

  _initBannerAd() {
    AdmobLoad admobLoad = AdmobLoad();
    _bannerAd = admobLoad.createBarnnerAd();
  }

  @override
  void initState() {
    _loading = true;
    _getUserLocation();
    readToken();
    _initBannerAd();
    super.initState();
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
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    TextEditingController destination = TextEditingController();

    _addPolyLine(List<LatLng> polylineCoordinates) {
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id,
        color:Colors.blue,
        points: polylineCoordinates,
        width: 8,
      );
      polylines[id] = polyline;
      setState(() {});
    }

    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: Consumer<Auth>(builder: (context, auth, child) {
          return auth.authenticated ? LoginDrawer() : NotLoginDrawer();
        }),
      ),
      backgroundColor: Colors.grey.shade200,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
        elevation: 10,
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        child: Container(
            height: deviceWidth * 0.18,
            width: deviceWidth * 0.18,
            child: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(70),
            )),
      ),
    ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : Container(
                child: Stack(
                  children: <Widget>[
                    GoogleMap(
                      polylines: Set<Polyline>.of(polylines.values),
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: 14.4746,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                      buildingsEnabled: true,
                    ),
                    Positioned(
                      child: DestinationTextField(
                          deviceHeight: deviceHeight,
                          deviceWidth: deviceWidth,
                          controller:destination,
                          onPressed:() async{
                            Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                            LatLng origin = LatLng(position.latitude, position.longitude);
                            List<LatLng> result = await Direction().getDirections(origin: origin,destination: destination.text);
                            _addPolyLine(result);
                          }
                      ),
                      top: deviceHeight * 0.07,
                      left: deviceWidth * 0.25,
                    ),
                    Positioned(child: MapScreenBottomBtn(), bottom: deviceHeight * 0.12),
                    Positioned(
                        child:currentLocationBtn(
                          deviceHeight: deviceHeight,
                          onPressed: _currentLocation,
                        ),
                      bottom: deviceHeight * 0.13,right:10
                    ),
                    Provider.of<Auth>(context).authenticated ? Positioned(
                        height: deviceHeight * 0.10,
                        width: deviceWidth,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                            color: Colors.white,
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Consumer<Status>(
                                    builder: (context, status, child) =>Text(
                                        '¥${status.status!.daysEarningsTotal}',
                                        textAlign:TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500
                                        ),
                                      )
                                ),
                              ),
                              Positioned(
                                  child: IconButton(
                                      onPressed: (){
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return FractionallySizedBox(
                                                  heightFactor: 0.90,
                                                  child: UserStatusScreen()
                                              );
                                            });
                                      },
                                      icon: Icon(Icons.list)
                                  ),
                                  height: deviceHeight * 0.10,
                                  right:0
                              ),
                            ],
                          ),
                        ),
                        bottom: 0,
                      ) : SizedBox.shrink()
                  ],
                ),
              ),
      ),
      bottomNavigationBar: _isAdLoaded
            ? Container(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd),
              )
            : SizedBox(),
      );
  }
}

class currentLocationBtn extends StatelessWidget {
  const currentLocationBtn({
    Key? key,
    required this.deviceHeight,
    required this.onPressed
  }) : super(key: key);

  final double deviceHeight;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight * 0.07,
      width: deviceHeight * 0.07,
      decoration:BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: IconButton(
          icon: Icon(Icons.my_location_outlined),
          onPressed:onPressed
      ),
    );
  }
}

class DestinationTextField extends StatelessWidget {
  const DestinationTextField({
    Key? key,
    required this.deviceHeight,
    required this.deviceWidth,
    required this.controller,
    required this.onPressed,
  }) : super(key: key);

  final double deviceHeight;
  final double deviceWidth;
  final TextEditingController controller;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight * 0.06,
      width: deviceWidth * 0.70,
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(10, 10))
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "配達先を検索",
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
