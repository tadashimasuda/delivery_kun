import 'package:delivery_kun/models/user_status.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:delivery_kun/services/user_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'screens/MapScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => Status()),
      ],
      child: MyApp(),
    ),
  );
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