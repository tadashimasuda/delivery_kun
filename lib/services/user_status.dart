import 'package:delivery_kun/models/user_status.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:intl/intl.dart';
import 'dio.dart';

class Status extends ChangeNotifier {
  UserStatus? _userStatus;
  DateTime _date = DateTime.now();

  UserStatus? get status => _userStatus;

  DateTime get date => _date;

  void getStatusDate(int user_id) {
    String date = DateFormat('yyyyMMdd').format(_date).toString();

    return getStatus(user_id, date);
  }

  void getStatusBeforeDate(int user_id) {
    _date = _date.add(Duration(days: -1));
    String date = DateFormat('yyyyMMdd').format(_date).toString();

    return getStatus(user_id, date);
  }

  void getStatusNextDate(int user_id) {
    if (DateFormat('yyyy年M月d日').format(DateTime.now()).toString() !=
        DateFormat('yyyy年M月d日').format(date)) {
      _date = _date.add(Duration(days: 1));
      String date = DateFormat('yyyyMMdd').format(_date).toString();

      return getStatus(user_id, date);
    }
  }

  void getStatusToday(int user_id) {
    String date = DateFormat('yyyyMMdd').format(DateTime.now()).toString();

    return getStatus(user_id, date);
  }

  void getStatus(int user_id, String date) async {
    try {
      Dio.Response response = await dio()
          .get('/status', queryParameters: {'date': date, 'user_id': user_id});

      if (response.statusCode == 204) {
        _userStatus = UserStatus(
            onlineTime: 'データがありません',
            actualCost: 0,
            daysEarningsQty: 0,
            daysEarningsTotal: 0,
            vehicleModel: '不明',
            hourQty: []);

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
          vehicleModel: '不明',
          hourQty: []);

      notifyListeners();
    }
  }
}
