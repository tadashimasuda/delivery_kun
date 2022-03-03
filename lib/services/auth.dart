import 'package:delivery_kun/models/user.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dio.dart';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  late User _user;
  late String _token;

  bool get authenticated => _isLoggedIn;
  User get user => _user;

  final storage = new FlutterSecureStorage();

  void tryToken(String? token) async{
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/user', options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        this._isLoggedIn = true;
        this._user = User.fromJson(response.data);
        this._token = token;
        this.storeToken(token);
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  void login({required Map creds}) async{
    try{
      Dio.Response response= await dio().post('/login',data:creds);
      String token = response.data['data']['access_token'].toString();
      this.tryToken(token);
    }catch(e){
      print(e);
    }

    notifyListeners();
  }

  void register({required Map creds}) async{
    try{
      Dio.Response response= await dio().post('/register',data:creds);
      String token = response.data['data']['access_token'].toString();
      this.tryToken(token);
    }catch(e){
      print(e);
    }

    notifyListeners();
  }

  Future storeToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  void logout() async {
    try {
      Dio.Response response = await dio().post('/logout', options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));

      // this._user = null;
      this._isLoggedIn = false;
      // this._token = null;
      await storage.delete(key: 'token');

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}