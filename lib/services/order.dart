import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as Dio;
import 'dio.dart';

import 'package:delivery_kun/models/order.dart';
import 'package:delivery_kun/services/auth.dart';

class OrderList extends ChangeNotifier {
  List<dynamic>? _orders;
  Order? _order;

  List<dynamic>? get orders => _orders;
  Order? get order => _order;
  Auth auth = Auth();

  void getOrders(String date) async {
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

  Future<void> postOrder({required String sheetId}) async {
    String? token = await auth.getToken();

    try {
       await dio().post('/order',
        data: {'sheetId': sheetId},
        options: Dio.Options(
            headers: {'Authorization': 'Bearer $token'}
        )
      );

      notifyListeners();
    } on Dio.DioError catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<bool> updateOrder({required Map requestData,required int id}) async {
    String? token = await auth.getToken();

    try {
      Dio.Response response = await dio().patch('/order/$id',
          data: requestData,
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'})
      );

      return true;
    } on Dio.DioError catch (e) {
      print(e.response?.statusCode);
      print(e.response?.statusMessage);
      return false;
    }
  }

  Future<bool> deleteOrder({required int id}) async {
    String? token = await auth.getToken();

    try {
      await dio().delete('/order/$id',
        data: {'id':id},
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'})
      );

      return true;
    } on Dio.DioError catch (e) {
      print(e.response?.statusCode);
      print(e.response?.statusMessage);

      return false;
    }
  }
}
