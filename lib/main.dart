import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart';

import 'package:delivery_kun/services/todayIncentive.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:delivery_kun/services/order.dart';
import 'package:delivery_kun/services/user_status.dart';
import 'package:delivery_kun/services/announcement.dart';
import 'package:delivery_kun/services/incentive_sheet.dart';
import 'package:delivery_kun/services/subscription.dart';
import 'package:delivery_kun/screens/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();

  MobileAds.instance.initialize();
  await Firebase.initializeApp();

  await Purchases.setDebugLogsEnabled(true);

  String apiKey = FlutterConfig.get('REVENUECAT_API_KEY');
  PurchasesConfiguration configuration = PurchasesConfiguration(apiKey);
  await Purchases.configure(configuration);
  if (Platform.isIOS) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => Status()),
        ChangeNotifierProvider(create: (context) => OrderList()),
        ChangeNotifierProvider(create: (context) => Incentive()),
        ChangeNotifierProvider(create: (context) => IncentiveSheet()),
        ChangeNotifierProvider(create: (context) => Announcement()),
        ChangeNotifierProvider(create: (context) => Subscription()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  final locale = const Locale("ja", "JP");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        locale,
      ],
      title: 'delivery-kun',
      home: const MapScreen(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [observer],
    );
  }
}
