import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:delivery_kun/services/admob.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:delivery_kun/services/direction.dart';
import 'package:delivery_kun/services/user_status.dart';
import 'package:delivery_kun/screens/user_status_screen.dart';
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
  Map<PolylineId, Polyline> _polylines = {};
  List<Marker> _markers = [];
  PolylinePoints polylinePoints = PolylinePoints();
  FlutterSecureStorage storage = FlutterSecureStorage();
  TextEditingController destinationController = TextEditingController();

  void _getUserLocation() async {
    final hasPermission = await MapScreen.handlePermission();

    if (!hasPermission) return;

    LatLng locaiton = await _getCurrentLocation();
    setState(() {
      _initialPosition = LatLng(locaiton.latitude, locaiton.longitude);
      _loading = false;
    });
  }

  Future<void> _getUser() async {
    String? token = await storage.read(key: 'token');
    if (token != null) {
      Provider.of<Auth>(context, listen: false).tryToken(token);
    }
  }

  Future<LatLng> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }

  void _currentLocation() async {
    LatLng locaiton = await _getCurrentLocation();
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(locaiton.latitude, locaiton.longitude), 14.4746));
  }

  void _initBannerAd() {
    AdmobLoad admobLoad = AdmobLoad();
    _bannerAd = admobLoad.createBarnnerAd();
  }

  @override
  void initState() {
    _loading = true;
    _getUserLocation();
    _getUser();
    _initBannerAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    void _addPolyLine(List<LatLng> polylineCoordinates) {
      PolylineId id = PolylineId("poly");
      setState(() {
        Polyline polyline = Polyline(
          polylineId: id,
          color: Colors.blue,
          points: polylineCoordinates,
          width: 8,
        );
        _polylines[id] = polyline;
      });
    }

    void _addEndLocationPoint(LatLng point,String start_address){
      _markers.add(
           Marker(
             markerId: MarkerId("marker1"),
             position: point,
             infoWindow: InfoWindow(title: start_address),
           )
       );
    }

    void _requestDestination(LatLng origin,String destinationText) async{
      var result = await Direction().getDirections(origin: origin, destination: destinationText);

      LatLng end_location = LatLng(result.data["routes"][0]["legs"][0]["end_location"]['lat'],result.data["routes"][0]["legs"][0]["end_location"]['lng']);
      String start_address = result.data["routes"][0]["legs"][0]["start_address"];

      List<PointLatLng> points= polylinePoints.decodePolyline(result.data["routes"][0]["overview_polyline"]["points"]);
      List<LatLng> polylineCoordinates = [];
      points.forEach((point) {
        polylineCoordinates.add(LatLng(point.latitude.toDouble(), point.longitude.toDouble()));
      });

      _addPolyLine(polylineCoordinates);
      _addEndLocationPoint(end_location,start_address);
    }

    void _clearPolylineMaker(){
      _polylines.clear();
      _markers.clear();
    }
    return Scaffold(
      resizeToAvoidBottomInset:false,
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: Consumer<Auth>(builder: (context, auth, child) {
          return auth.authenticated ? LoginDrawer() : NotLoginDrawer();
        }),
      ),
      backgroundColor: Colors.grey.shade200,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Builder(
        builder: (context) =>
            FloatingActionButton(
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
                markers: Set<Marker>.of(_markers),
                polylines: Set<Polyline>.of(_polylines.values),
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
                onTap: (LatLng latLng){
                  FocusScope.of(context).unfocus();
                },
              ),
              Positioned(
                child: destinationTextField(
                    deviceHeight: deviceHeight,
                    deviceWidth: deviceWidth,
                    TextFormField: TextFormField(
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (value) async{
                      LatLng origin = await _getCurrentLocation();
                      if(value != null){
                        value.isNotEmpty ? _requestDestination(origin,value) : _clearPolylineMaker();
                      }
                      FocusScope.of(context).unfocus();
                    },
                    controller: destinationController,
                    decoration: InputDecoration(
                      hintText: "配達先を検索",
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        onPressed: () async {
                          LatLng origin = await _getCurrentLocation();
                          destinationController.text.isNotEmpty ? _requestDestination(origin,destinationController.text) : _clearPolylineMaker();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ),

                ),
                top: deviceHeight * 0.07,
                left: deviceWidth * 0.25,
              ),
              Consumer<Auth>(
                  builder: (context, auth, child) {
                    return Positioned(
                        child: MapScreenBottomBtn(),
                        bottom: auth.authenticated != false ? deviceHeight * 0.12 :  deviceHeight * 0.02
                    );
                  }
              ),
              Consumer<Auth>(
                  builder: (context, auth, child) {
                    return Positioned(
                      child: currentLocationBtn(
                        deviceHeight: deviceHeight,
                        onPressed: _currentLocation,
                      ),
                      bottom: auth.authenticated != false ? deviceHeight * 0.12 :  deviceHeight * 0.02,right: 10,
                    );
                  }
              ),
              Consumer<Auth>(
                  builder: (context, auth, child) {
                    auth.authenticated ? Provider.of<Status>(context,listen: false).getStatusToday(auth.user.id) : false;
                    return auth.authenticated != false ? Positioned(
                      height: deviceHeight * 0.10,
                      width: deviceWidth,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Consumer<Status>(
                                  builder: (context, status, child) {
                                    return status.status?.daysEarningsTotal != null ?
                                    Text(
                                      '¥${status.status?.daysEarningsTotal}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ) : Text(
                                      'データが取得できませんでした',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500
                                      ),
                                    );
                                  }),
                            ),
                            Positioned(
                                child: IconButton(
                                    onPressed: () {
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
                                right: 0
                            ),
                          ],
                        ),
                      ),
                      bottom: 0,
                    ) : SizedBox.shrink();
                  }
              )
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

class destinationTextField extends StatelessWidget {
  const destinationTextField({
    Key? key,
    required this.deviceHeight,
    required this.deviceWidth,
    required this.TextFormField
  }) : super(key: key);

  final double deviceHeight;
  final double deviceWidth;
  final Widget TextFormField;

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
      child: TextFormField,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(10, 10))
        ],
      ),
      child: IconButton(
          icon: Icon(Icons.my_location_outlined),
          onPressed: onPressed
      ),
    );
  }
}