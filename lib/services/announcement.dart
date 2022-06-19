import 'package:delivery_kun/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as Dio;
import 'dio.dart';

class Announcement extends ChangeNotifier {
  late List<dynamic> _announcements;
  late int _is_not_read_num = 0;

  List<dynamic> get announcements => _announcements;
  int get is_not_read_num => _is_not_read_num;

  Auth auth = Auth();

  Future<void> getAnnouncements() async{
    try {
      String? token = await auth.getToken();

      Dio.Response response = await dio().get('/announcement',
          options: Dio.Options(
            headers: {'Authorization': 'Bearer $token'}
          ),
      );

      Map<String, dynamic> announcementsJson = Map<String, dynamic>.from(response.data);
      _announcements = announcementsJson["data"];

      _is_not_read_num = 0;
      for(var i in _announcements){
        if(i['read'] == null){
          _is_not_read_num++;
        }
      }

      notifyListeners();
    } on Dio.DioError catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<void> readAnnouncement({required int id}) async{
    try {
      String? token = await auth.getToken();

      await dio().post(
        '/announcement/' + id.toString(),
        options: Dio.Options(
            headers: {'Authorization': 'Bearer $token'}
        ),
      );

      notifyListeners();
    } on Dio.DioError catch (e) {
      print(e);
      notifyListeners();
    }
  }
}