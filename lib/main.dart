import 'package:delivery_kun/services/auth.dart';
import 'package:delivery_kun/services/order.dart';
import 'package:delivery_kun/services/user_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'screens/map_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize(q);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => Status()),
        ChangeNotifierProvider(create: (context) => OrderList()),
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
