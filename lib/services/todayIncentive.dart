import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as Dio;
import 'dio.dart';

import 'package:delivery_kun/services/auth.dart';

class Incentive extends ChangeNotifier {
  Auth auth = Auth();
  List<dynamic>? _incentives;
  bool _is_incentives = false;

  List<dynamic>? get incentives => _incentives;
  bool get is_incentives => _is_incentives;

  Future<void> getTodayIncentive() async {
    String? token = await auth.getToken();
    try {
      Dio.Response response = await dio().get('/incentive',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode != 204) {
        _is_incentives = true;
        _incentives = response.data['data'];

        notifyListeners();
      }

      notifyListeners();
    } on Dio.DioError catch (e) {
      print(e);
      notifyListeners();
    }
  }

  void postTodayIncentive({required List<dynamic>? incentives}) async {
    String? token = await auth.getToken();

    try {
      await dio().post('/incentive',
          data: {'data': incentives},
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));

      notifyListeners();
    } on Dio.DioError catch (e) {
      print(e.response?.statusCode);
      notifyListeners();
    }
  }
}
