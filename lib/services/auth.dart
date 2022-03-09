import 'package:delivery_kun/models/user.dart';
import 'package:delivery_kun/models/validate.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dio.dart';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _user;
  String? _token;
  Validate? _validate_message;

  bool get authenticated => _isLoggedIn;
  User get user => _user!;
  Validate? get validate_message => _validate_message;

  final storage = new FlutterSecureStorage();

  void tryToken(String? token) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/user',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'})
        );
        _isLoggedIn = true;
        _user = User.fromJson(response.data);
        _validate_message = null;
        _token = token;
        storeToken(token);
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool> login({required Map creds}) async {
    try {
      Dio.Response response = await dio().post('/login', data: creds);
      String token = response.data['data']['access_token'].toString();
      tryToken(token);

      notifyListeners();

      return true;
    } on Dio.DioError catch (e) {
      if (e.response?.statusCode == 422) {
        var response = e.response?.data;
        _validate_message = Validate.fromJson(response);
        notifyListeners();

        return false;
      }else{
        _validate_message = Validate(['メールアドレスとパスワードが一致しませんでした。'],['']);
        notifyListeners();

        return false;
      }
    }
  }

  void register({required Map creds}) async {
    try {
      Dio.Response response = await dio().post('/register', data: creds);
      String token = response.data['data']['access_token'].toString();
      tryToken(token);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future storeToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  void logout() async {
    try {
      await dio().post('/logout', options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));

      _user = null;
      _isLoggedIn = false;
      _token = '';
      await storage.delete(key: 'token');

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
