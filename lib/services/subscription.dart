import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Subscription extends ChangeNotifier {
  bool _isSubscribed = false;
  Offerings? _offerings;
  CustomerInfo? _restoredCustomerInfo;

  bool get hasSubscribed => _isSubscribed;
  Offerings? get offerings => _offerings;
  CustomerInfo? get restoredCustomerInfo => _restoredCustomerInfo;

  void errorLog(e) {
    final errorCode = PurchasesErrorHelper.getErrorCode(e);
    if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
      print(errorCode);
    }
  }

  Future<void> getCustomerInfo(String entitlementID) async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.active[entitlementID] != null &&
          customerInfo.entitlements.active[entitlementID]!.isActive == true) {
        _isSubscribed = true;

        notifyListeners();
      }
    } on PlatformException catch (e) {
      errorLog(e);
    }
  }

  Future<void> getOffers() async {
    _offerings = await Purchases.getOfferings();

    notifyListeners();
  }

  Future<void> makePurchase(Package package) async {
    try {
      CustomerInfo purchaserInfo = await Purchases.purchasePackage(package);
      bool isActive =
          purchaserInfo.entitlements.all["subscription_1m"]!.isActive;

      if (isActive) {
        _isSubscribed = true;
      }

      notifyListeners();
    } on PlatformException catch (e) {
      errorLog(e);
    }
  }

  Future<void> restorePurchases() async {
    try {
      _restoredCustomerInfo = await Purchases.restorePurchases();

      notifyListeners();
    } on PlatformException catch (e) {
      errorLog(e);
    }
  }
}
