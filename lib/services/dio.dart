import 'package:dio/dio.dart';

Dio dio(){
  var dio = new Dio();

  dio.options.baseUrl = "http://localhost:8000/api";
  dio.options.headers['Accept'] = 'Application/json';

  return dio;
}