import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'screens/MapScreen.dart';

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
      home: MapScreen(),
    );
  }
}