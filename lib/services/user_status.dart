import 'package:delivery_kun/models/user_status.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:delivery_kun/services/auth.dart';
import 'dio.dart';

class Status extends ChangeNotifier {
  late UserStatus _userStatus;

  UserStatus get status => _userStatus;

  String getDate() {
    return DateFormat('yyyyMMdd').format(DateTime.now()).toString();
  }

  void getStatus(int user_id) async {
    String date = getDate();

    Dio.Response response = await dio()
        .get('/status', queryParameters: {'date': date, 'user_id': user_id});
    _userStatus = UserStatus.fromJson(response.data);

    notifyListeners();
  }
}
