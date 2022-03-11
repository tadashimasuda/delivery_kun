import 'package:delivery_kun/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as Dio;
import 'dio.dart';

class OrderList extends ChangeNotifier {
  List<dynamic>? _orders;

  List<dynamic> get orders => _orders!;

  void getOrders(int user_id, String date) async {
    Auth auth = Auth();
    String? token = await auth.getToken();
    try {
      Dio.Response response = await dio().get('/order',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
          queryParameters: {'date': date, 'user_id': user_id});

      Map<String, dynamic> ordersJson =
          Map<String, dynamic>.from(response.data);
      _orders = ordersJson["data"];

      notifyListeners();
    } on Dio.DioError catch (e) {
      print(e);
      notifyListeners();
    }
  }

  void postOrder() async {
    Auth auth = Auth();
    String? token = await auth.getToken();
    try {
      Dio.Response response = await dio().post('/order',
          data: {'earnings_incentive': 1.5},
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      notifyListeners();
    } on Dio.DioError catch (e) {
      print(e);
      notifyListeners();
    }
  }
}
