import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:dio/dio.dart' as Dio;

class Direction extends ChangeNotifier {
  PolylinePoints polylinePoints = PolylinePoints();

  Future<dynamic> getDirections({required LatLng origin,required String destination}) async {
    String key = FlutterConfig.get('GOOGLEMAP_API_KEY');
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=$destination&mode=DRIVING&optimizeWaypoints=true&alternative=true&language=ja&key=$key";

    var response = await dio().get(url);

    notifyListeners();

    return response;
  }
}
