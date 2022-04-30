import 'package:delivery_kun/models/order.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as Dio;
import 'dio.dart';

class OrderList extends ChangeNotifier {
  List<dynamic>? _orders;
  Order? _order;

  List<dynamic>? get orders => _orders;
  Order? get order => _order;

  void getOrders(String date) async {
    Auth auth = Auth();
    String? token = await auth.getToken();

    try {
      Dio.Response response = await dio().get('/order',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
          queryParameters: {'date': date});

      Map<String, dynamic> ordersJson =
          Map<String, dynamic>.from(response.data);
      _orders = ordersJson["data"];

      notifyListeners();
    } on Dio.DioError catch (e) {
      print(e);
      notifyListeners();
    }
  }

  void getOrder(int id) async {
    Auth auth = Auth();
    String? token = await auth.getToken();
    try {
      Dio.Response response = await dio().get('/order/$id',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));

      _order = Order.fromJson(response.data);
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
          data: {'earnings_incentive': 1.0},
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      notifyListeners();
    } on Dio.DioError catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<bool> updateOrder({required Map requestData,required int id}) async {
    Auth auth = Auth();
    String? token = await auth.getToken();

    try {
      Dio.Response response = await dio().patch('/order/$id',
          data: requestData,
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));

      return true;
    } on Dio.DioError catch (e) {
      print(e.response?.statusCode);
      print(e.response?.statusMessage);
      return false;
    }
  }

  Future<bool> deleteOrder({required int id}) async {
    Auth auth = Auth();
    String? token = await auth.getToken();

    try {
      await dio().delete('/order/$id',
          data: {'id':id},
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));

      return true;
    } on Dio.DioError catch (e) {
      print(e.response?.statusCode);
      print(e.response?.statusMessage);

      return false;
    }
  }
}
