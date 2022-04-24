import 'package:dio/dio.dart';

Dio dio(){
  var dio = new Dio();

  dio.options.baseUrl = "http://localhost:8000/api";
  // dio.options.baseUrl = "https://deliverykun-server.xyz/api";
  // dio.options.baseUrl = "https://tmasuda.sakura.ne.jp/delivery_kun_backend/public/api";
  dio.options.headers['Accept'] = 'Application/json';

  return dio;
}