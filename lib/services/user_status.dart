import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as Dio;
import 'dio.dart';

import 'package:delivery_kun/models/user_status.dart';
import 'package:delivery_kun/services/auth.dart';

class Status extends ChangeNotifier {
  UserStatus? _userStatus;
  int _userDaysEarningsTotal = 0;
  DateTime _date = DateTime.now();

  UserStatus? get status => _userStatus;
  int get userDaysEarningsTotal => _userDaysEarningsTotal;
  DateTime get date => _date;

  Auth auth = Auth();

  void getStatusDate(int user_id) async {
    String date = DateFormat('yyyyMMdd').format(_date).toString();

    getStatus(user_id,date);
  }

  void getStatusBeforeDate(int user_id) async {
    _date = _date.add(Duration(days: -1));
    String date = DateFormat('yyyyMMdd').format(_date).toString();

    getStatus(user_id,date);
  }

  void getStatusNextDate(int user_id) async {
    if (DateFormat('yyyy年M月d日').format(DateTime.now()).toString() != DateFormat('yyyy年M月d日').format(date)) {
      _date = _date.add(Duration(days: 1));
      String date = DateFormat('yyyyMMdd').format(_date).toString();

      getStatus(user_id,date);
    }
  }

  Future<void> getStatusToday(int user_id) async{
    String date = DateFormat('yyyyMMdd').format(DateTime.now()).toString();

    await getStatus(user_id,date);
  }

  Future<void> getStatus(int user_id,String date) async {
    try {
      Dio.Response response = await dio().get(
        '/status',
        queryParameters: {
          'date': date,
          'user_id': user_id
        }
      );

      if (response.statusCode == 204) {
        _userStatus = UserStatus(
          onlineTime: 'データがありません',
          actualCost: 0,
          daysEarningsQty: 0,
          daysEarningsTotal: 0,
          vehicleModel: '不明',
          hourQty: []
        );
      }else{
        _userStatus = UserStatus.fromJson(response.data);

        if(date == DateFormat('yyyyMMdd').format(DateTime.now()).toString()){
          _userDaysEarningsTotal = _userStatus!.daysEarningsTotal;
        }
      }

      notifyListeners();
    } on Dio.DioError catch (e) {
      if (e.response?.statusCode == 429) {
        _userStatus = UserStatus(
          onlineTime: 'アクセス過多',
          actualCost: 0,
          daysEarningsQty: 0,
          daysEarningsTotal: 0,
          vehicleModel: '不明',
          hourQty: []);
      }
      _userStatus = UserStatus(
          onlineTime: 'エラー',
          actualCost: 0,
          daysEarningsQty: 0,
          daysEarningsTotal: 0,
          vehicleModel: '不明',
          hourQty: []);

      notifyListeners();
    }
  }

  Future<bool> updateAcutualCost({required int actualCost}) async {
    Auth auth = Auth();

    String date = DateFormat('yyyyMMdd').format(_date).toString();
    String? token = await auth.getToken();

    try {
      await dio().patch(
          '/actual_cost',
          data:{
            'actual_cost':actualCost,
          },
          options: Dio.Options(
              headers: {'Authorization': 'Bearer $token'},
              ),
          queryParameters: {
            'date': date
          },
      );

      notifyListeners();

      return true;
    } on Dio.DioError catch (e) {
      notifyListeners();

      return false;
    }
  }
}
