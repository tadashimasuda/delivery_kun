import 'dart:async';
import 'dart:io' show Platform;

import 'package:app_review/app_review.dart';
import 'package:delivery_kun/components/adBanner.dart';
import 'package:delivery_kun/components/loggedIn_drawer.dart';
import 'package:delivery_kun/components/map_screen_bottom_btn.dart';
import 'package:delivery_kun/components/notLoggedIn_drawer.dart';
import 'package:delivery_kun/components/userDaysTotalBottomSheet.dart';
import 'package:delivery_kun/services/admob.dart';
import 'package:delivery_kun/services/announcement.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:delivery_kun/services/direction.dart';
import 'package:delivery_kun/services/incentive_sheet.dart';
import 'package:delivery_kun/services/subscription.dart';
import 'package:delivery_kun/services/user_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Completer<GoogleMapController> _controller = Completer();

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  static void showAlert(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('このアプリを利用するには位置情報取得許可が必要です。'),
            content: const Text("位置情報を利用します"),
            actions: <Widget>[
              TextButton(
                child: const Text("キャンセル"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("設定"),
                onPressed: () async {
                  openAppSettings();
                },
              ),
            ],
          );
        });
  }

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
  late bool isAuthenticated;
  late AdmobLoad admobLoad;
  final Map<PolylineId, Polyline> _polylines = {};
  final List<Marker> _markers = [];
  PolylinePoints polylinePoints = PolylinePoints();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  TextEditingController destinationController = TextEditingController();
  bool _isSubscribed = false;

  void _getUserLocation() async {
    final hasPermission = await MapScreen.handlePermission();

    if (!hasPermission) {
      Platform.isIOS
          ? showCupertinoDialog(
              context: context,
              builder: (context) {
                return IOSPermissionAlertDialog(context);
              })
          : showDialog(
              context: context,
              builder: (context) {
                return AndroidAlertPermissionDialog(context);
              });
    }

    LatLng locaiton = await _getCurrentLocation();
    setState(() {
      _initialPosition = LatLng(locaiton.latitude, locaiton.longitude);
      _loading = false;
    });
  }

  void _hasSubscription() async {
    await context.read<Subscription>().getCustomerInfo('subscription_1m');
  }

  CupertinoAlertDialog IOSPermissionAlertDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('このアプリを利用するには位置情報取得許可が必要です'),
      content: const Text('設定画面で位置情報の許可をしてください'),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('キャンセル'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: const Text('設定'),
          onPressed: () async {
            await openAppSettings();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  AlertDialog AndroidAlertPermissionDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('このアプリを利用するには位置情報取得許可が必要です'),
      content: const Text("位置情報を利用します"),
      actions: <Widget>[
        TextButton(
          child: const Text("キャンセル"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("設定"),
          onPressed: () async {
            await openAppSettings();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Future<void> _getUserData() async {
    String? token = await storage.read(key: 'token');
    if (token != null) {
      await context.read<Auth>().tryToken(token);
      await context.read<IncentiveSheet>().getIncentives();
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

  void _getAnnouncement() async {
    await context.read<Announcement>().getAnnouncements();
  }

  void _requestReview() {
    if (Platform.isIOS) {
      AppReview.requestReview.then((onValue) {
        print(onValue);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    _getUserLocation();
    _getUserData();
    _getAnnouncement();
    _hasSubscription();
    // _requestReview();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    _isSubscribed = context.watch<Subscription>().hasSubscribed;

    void _addPolyLine(List<LatLng> polylineCoordinates) {
      PolylineId id = const PolylineId("poly");
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

    void _addEndLocationPoint(LatLng point, String startAddress) {
      _markers.add(Marker(
        markerId: const MarkerId("marker1"),
        position: point,
        infoWindow: InfoWindow(title: startAddress),
      ));
    }

    void _requestDestination(LatLng origin, String destinationText) async {
      var result = await Direction()
          .getDirections(origin: origin, destination: destinationText);

      LatLng endLocation = LatLng(
          result.data["routes"][0]["legs"][0]["end_location"]['lat'],
          result.data["routes"][0]["legs"][0]["end_location"]['lng']);
      String startAddress =
          result.data["routes"][0]["legs"][0]["start_address"];

      List<PointLatLng> points = polylinePoints.decodePolyline(
          result.data["routes"][0]["overview_polyline"]["points"]);
      List<LatLng> polylineCoordinates = [];
      points.forEach((point) {
        polylineCoordinates
            .add(LatLng(point.latitude.toDouble(), point.longitude.toDouble()));
      });

      _addPolyLine(polylineCoordinates);
      _addEndLocationPoint(endLocation, startAddress);
    }

    void _clearPolylineMaker() {
      _polylines.clear();
      _markers.clear();
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawerEnableOpenDragGesture: false,
        drawer: Drawer(
          child: Consumer<Auth>(builder: (context, auth, child) {
            return auth.authenticated
                ? const LoggedInDrawer()
                : NotLoggedInDrawer();
          }),
        ),
        backgroundColor: Colors.grey.shade200,
        body: Consumer<Auth>(builder: (context, auth, child) {
          auth.authenticated
              ? context.read<Status>().getStatusToday(auth.user!.id)
              : false;
          return Center(
              child: _loading
                  ? const CircularProgressIndicator()
                  : Stack(children: <Widget>[
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
                        onTap: (LatLng latLng) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      Positioned(
                        width: deviceWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FloatingActionButton(
                              elevation: 10,
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              child: Container(
                                  height: deviceWidth * 0.18,
                                  width: deviceWidth * 0.18,
                                  child: const Icon(
                                    Icons.menu,
                                    color: Colors.black,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(70),
                                  )),
                            ),
                            DestinationTextField(
                              deviceHeight: deviceHeight,
                              deviceWidth: deviceWidth,
                              textFormField: TextFormField(
                                textInputAction: TextInputAction.search,
                                onFieldSubmitted: (value) async {
                                  LatLng origin = await _getCurrentLocation();
                                  if (value != '') {
                                    value.isNotEmpty
                                        ? _requestDestination(origin, value)
                                        : _clearPolylineMaker();
                                  }
                                  FocusScope.of(context).unfocus();
                                },
                                controller: destinationController,
                                decoration: InputDecoration(
                                  hintText: "配達先を検索",
                                  border: InputBorder.none,
                                  suffixIcon: destinationController.text.isEmpty
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.search,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () async {
                                            LatLng origin =
                                                await _getCurrentLocation();
                                            destinationController
                                                    .text.isNotEmpty
                                                ? _requestDestination(origin,
                                                    destinationController.text)
                                                : _clearPolylineMaker();
                                            FocusScope.of(context).unfocus();
                                          },
                                        )
                                      : IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            destinationController.clear();
                                            _clearPolylineMaker();
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        top: 50,
                      ),
                      Positioned(
                          child: const MapScreenBottomBtn(),
                          bottom: auth.authenticated != false
                              ? deviceHeight * 0.12
                              : deviceHeight * 0.02),
                      Positioned(
                        child: CurrentLocationBtn(
                          deviceHeight: deviceHeight,
                          onPressed: _currentLocation,
                        ),
                        bottom: auth.authenticated != false
                            ? deviceHeight * 0.12
                            : deviceHeight * 0.02,
                        right: 10,
                      ),
                      auth.authenticated != false
                          ? Positioned(
                              child: DaysEarningsTotalBottomSheet(
                                  deviceHeight: deviceHeight),
                              height: deviceHeight * 0.10,
                              width: deviceWidth,
                              bottom: 0,
                            )
                          : const SizedBox.shrink()
                    ]));
        }),
        bottomNavigationBar: _isSubscribed != true ? const AdBanner() : null);
  }
}

class DestinationTextField extends StatelessWidget {
  const DestinationTextField(
      {Key? key,
      required this.deviceHeight,
      required this.deviceWidth,
      required this.textFormField})
      : super(key: key);

  final double deviceHeight;
  final double deviceWidth;
  final Widget textFormField;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight * 0.06,
      width: deviceWidth * 0.70,
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(10, 10))
        ],
      ),
      child: textFormField,
    );
  }
}

class CurrentLocationBtn extends StatelessWidget {
  const CurrentLocationBtn(
      {Key? key, required this.deviceHeight, required this.onPressed})
      : super(key: key);

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
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(10, 10))
        ],
      ),
      child: IconButton(
          icon: const Icon(Icons.my_location_outlined), onPressed: onPressed),
    );
  }
}
