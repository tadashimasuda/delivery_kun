import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'main_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'delivery-kun',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  late LatLng _initialPosition;
  late bool _loading;

  void _getUserLocation() async {
    final hasPermission = await _handlePermission();

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

  Future<bool> _handlePermission() async {
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
  void initState() {
    super.initState();
    _loading = true;
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: mainDrawer(),
      ),
      backgroundColor: Colors.grey.shade200,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          elevation: 20,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.blue, width: 3),
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: NetworkImage(
                      "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80"),
                )),
          ),
        ),
      ),
      body: SlidingSheet(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
            // Enable snapping. This is true by default.
            snap: true,
            // Set custom snapping points.
            snappings: [0.5, 0.7, 1.0],
            // Define to what the snappings relate to. In this case,
            // the total available space that the sheet can expand to.
            positioning: SnapPositioning.relativeToSheetHeight),
        // The body widget will be displayed under the SlidingSheet
        // and a parallax effect can be applied to it.
        body: Center(
          child: _loading
              ? CircularProgressIndicator()
              : Container(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
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
                        myLocationButtonEnabled: true,
                        mapToolbarEnabled: false,
                        buildingsEnabled: true,
                        onTap: (LatLng latLang) {
                          print('Clicked: $latLang');
                        },
                      ),
                    ],
                  ),
                ),
        ),

        builder: (context, state) {
          return Container(
            height: 200,
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        padding: EdgeInsets.all(30),
                        onPressed: () {},
                        color: Colors.red[50],
                        shape: CircleBorder(), //丸
                        child: const Text(
                          '×1.0',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MaterialButton(
                        padding: EdgeInsets.all(30),
                        onPressed: () {},
                        color: Colors.red[100],
                        shape: CircleBorder(), //丸
                        child: const Text(
                          '×1.1',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MaterialButton(
                        padding: EdgeInsets.all(30),
                        onPressed: () {},
                        color: Colors.red[200],
                        shape: CircleBorder(), //丸
                        child: Text(
                          '×1.2',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MaterialButton(
                        padding: EdgeInsets.all(30),
                        onPressed: () {},
                        color: Colors.red[300],
                        shape: CircleBorder(), //丸
                        child: Text(
                          '×1.3',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MaterialButton(
                        padding: EdgeInsets.all(30),
                        onPressed: () {},
                        color: Colors.red[400],
                        shape: CircleBorder(), //丸
                        child: Text(
                          '×1.4',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MaterialButton(
                        padding: EdgeInsets.all(30),
                        onPressed: () {},
                        color: Colors.red[500],
                        shape: CircleBorder(), //丸
                        child: Text(
                          '×1.0',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(
                  flex: 5,
                ),
                SizedBox(
                  width: 300, //横幅
                  height: 50, //高さ
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('配達を開始する'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, //ボタンの背景色
                    ),
                  ),
                ),
                Spacer(
                  flex: 5,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
