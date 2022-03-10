import 'package:delivery_kun/models/user_status.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:intl/intl.dart';
import 'package:delivery_kun/services/auth.dart';
import 'dio.dart';

class Status extends ChangeNotifier {
  UserStatus? _userStatus;

  UserStatus? get status => _userStatus;

  String getDate() {
    return DateFormat('yyyyMMdd').format(DateTime.now()).toString();
  }

  void getStatus(int user_id) async {
    try {
      String date = getDate();

      Dio.Response response = await dio()
          .get('/status', queryParameters: {'date': date, 'user_id': user_id});

      if (response.statusCode == 204) {
        _userStatus = UserStatus(
            onlineTime: 'データがありません',
            actualCost: 0,
            daysEarningsQty: 0,
            daysEarningsTotal: 0,
            vehicleModel: '不明');

        notifyListeners();

        return;
      }

      _userStatus = UserStatus.fromJson(response.data);

      notifyListeners();
    } on Dio.DioError catch (e) {
      _userStatus = UserStatus(
          onlineTime: 'エラー:${e.response!.statusCode}',
          actualCost: 0,
          daysEarningsQty: 0,
          daysEarningsTotal: 0,
          vehicleModel: '不明');

      notifyListeners();
    }
  }
}
