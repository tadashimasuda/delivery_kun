import 'package:delivery_kun/components/account_form_btn.dart';
import 'package:delivery_kun/components/account_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _name = '';
  String _email = '';
  String _selectVehicleModel = '';
  String _selectPrefecture = '';

  var _text = 'Hello';

  List<String> _prefectureList = ['東京', '埼玉', '栃木'];
  List<String> _VehicleModelList = ['バイク', '自転車', '車', '徒歩'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('設定画面'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
        child: Column(
          children: [
            AccountTextField(
              obscureText: false,
              title: 'ユーザ名',
              icon: Icons.person,
              onChange: (value) {
                _name = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            AccountTextField(
              obscureText: false,
              title: 'メールアドレス',
              icon: Icons.mail,
              onChange: (value) {
                _email = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: TextEditingController(text: _selectVehicleModel),
              readOnly: true,
              decoration: InputDecoration(
                  labelText: '配達車両',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: CupertinoPicker(
                          itemExtent: 30,
                          onSelectedItemChanged: (val) {
                            setState(() {
                              _selectVehicleModel = _VehicleModelList[val];
                            });
                          },
                          children:
                              _VehicleModelList.map((e) => Text(e)).toList(),
                        ),
                      );
                    });
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: TextEditingController(text: _selectPrefecture),
              readOnly: true,
              decoration: InputDecoration(
                  labelText: '活動場所',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: CupertinoPicker(
                          itemExtent: 30,
                          onSelectedItemChanged: (val) {
                            setState(() {
                              _selectPrefecture = _prefectureList[val];
                            });
                          },
                          children:
                              _prefectureList.map((e) => Text(e)).toList(),
                        ),
                      );
                    });
              },
            ),
            SizedBox(
              height: 20,
            ),
            SubmitBtn(
                title: '更新',
                color: Colors.lightBlue,
                onTap: () {}
            )
          ],
        ),
      ),
    );
  }
}
