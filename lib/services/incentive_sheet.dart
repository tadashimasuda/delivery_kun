import 'package:delivery_kun/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:delivery_kun/models/incentive_sheet.dart';
import 'dio.dart';
import 'dart:convert';

import 'package:delivery_kun/services/auth.dart';

class IncentiveSheet extends ChangeNotifier{
  Auth auth = Auth();
  List<IncentiveSheetModel> _IncentivesSheets = [];
  bool _isInsentivesSheet = false;

  late IncentiveSheetModel _IncentivesSheet;

  List<IncentiveSheetModel> get IncentivesSheets => _IncentivesSheets;
  bool get isInsentivesSheet => _isInsentivesSheet;

  IncentiveSheetModel get IncentivesSheet => _IncentivesSheet;

  Future<void> getIncentives() async{
    String? token = await auth.getToken();
    try {
      Dio.Response response = await dio().get(
          '/incentive_sheets',
          options: Dio.Options(headers: {
            'Authorization': 'Bearer $token'
          })
      );

      if(response != null){
        _isInsentivesSheet = true;
        _IncentivesSheets.clear();

        response.data['data'].forEach((item) {
          _IncentivesSheets.add(IncentiveSheetModel.fromJson(item));
        });
        notifyListeners();
      }

      notifyListeners();
    } on Dio.DioError catch (e) {
      print(e);
    }
  }

  Future<void> getIncentive({required String id}) async{
    String? token = await auth.getToken();
    try {
      Dio.Response response = await dio().get(
          '/incentive_sheets/' + id,
          options: Dio.Options(headers: {
            'Authorization': 'Bearer $token'
          })
      );

      if(response != null){
        _IncentivesSheet = IncentiveSheetModel.fromJson(response.data['data']);

        notifyListeners();
      }

      notifyListeners();
    } on Dio.DioError catch (e) {
      print(e);
    }
  }

  Future<void> updateIncentive({required String id,required Map requestBody}) async{
    String? token = await auth.getToken();
    try {
      await dio().patch(
        '/incentive_sheets/' + id,
          data: requestBody,
          options: Dio.Options(headers: {
          'Authorization': 'Bearer $token'
        }),
      );

      notifyListeners();
    } on Dio.DioError catch (e) {
      print(e);
    }
  }

  Future<void> postIncentive({required Map requestBody}) async{
    String? token = await auth.getToken();
    try {
      await dio().post(
        '/incentive_sheets',
        data: requestBody,
        options: Dio.Options(headers: {
          'Authorization': 'Bearer $token'
        }),
      );

      notifyListeners();
    } on Dio.DioError catch (e) {
      print(e);
    }
  }

  Future<void> deleteIncentive({required String id}) async{
    String? token = await auth.getToken();
    try {
      await dio().delete(
        '/incentive_sheets/' + id,
        options: Dio.Options(headers: {
          'Authorization': 'Bearer $token'
        }),
      );

      notifyListeners();
    } on Dio.DioError catch (e) {
      print(e);
    }
  }

}