import 'package:delivery_kun/components/account_form_btn.dart';
import 'package:delivery_kun/components/account_text_field.dart';
import 'package:delivery_kun/screens/map_screen.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:delivery_kun/mixins/validate_text.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with ValidateText {
  String _name = '';
  String _email = '';
  int _selectVehicleModelNumber = 1;
  int _selectPrefectureNumber = 1;

  List<String> _prefectureList = ['東京', '埼玉', '栃木'];
  List<String> _VehicleModelList = ['バイク', '自転車', '車', '徒歩'];

  @override
  void initState() {
    Auth auth = context.read<Auth>();
    _name = auth.user.name;
    _email = auth.user.email;
    _selectVehicleModelNumber = auth.user.vehicleModel;
    _selectPrefectureNumber = auth.user.prefectureId;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ユーザー設定'),
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Consumer<Auth>(builder: (context, auth, _) {
            return Column(
              children: [
                AccountTextField(
                  inputText: auth.user.name,
                  obscureText: false,
                  title: 'ユーザ名',
                  icon: Icons.person,
                  onChange: (value) {
                    _name = value;
                  },
                ),
                Column(
                  children: ValidateUserName(auth.validate_message),
                ),
                SizedBox(
                  height: 20,
                ),
                AccountTextField(
                  inputText: auth.user.email,
                  obscureText: false,
                  title: 'メールアドレス',
                  icon: Icons.mail,
                  onChange: (value) {
                    _email = value;
                  },
                ),
                Column(
                  children: ValidateEmail(auth.validate_message),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: TextEditingController(
                      text: _VehicleModelList[_selectVehicleModelNumber]),
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: '配達車両',
                      suffixIcon: Icon(Icons.directions_bike),
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
                                  _selectVehicleModelNumber = val;
                                });
                              },
                              children: _VehicleModelList.map((e) => Text(e))
                                  .toList(),
                              scrollController: FixedExtentScrollController(
                                  initialItem: auth.user.vehicleModel),
                            ),
                          );
                        });
                  },
                ),
                Column(
                  children: ValidateVehicleModel(auth.validate_message),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: TextEditingController(
                      text: _prefectureList[_selectPrefectureNumber]),
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: _prefectureList[_selectPrefectureNumber],
                      suffixIcon: Icon(Icons.location_on),
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
                                  _selectPrefectureNumber = val;
                                  print(_selectPrefectureNumber);
                                });
                              },
                              children:
                                  _prefectureList.map((e) => Text(e)).toList(),
                              scrollController: FixedExtentScrollController(
                                  initialItem: _selectPrefectureNumber),
                            ),
                          );
                        });
                  },
                ),
                Column(
                  children: ValidatePrefecture(auth.validate_message),
                ),
                SizedBox(
                  height: 20,
                ),
                SubmitBtn(
                    title: '更新',
                    color: Colors.lightBlue,
                    onTap: () async {
                      Map userData = {
                        'email': _email,
                        'name': _name,
                        'prefectureId': _selectPrefectureNumber,
                        'vehicleModelId': _selectVehicleModelNumber
                      };
                      bool response =
                          await Provider.of<Auth>(context, listen: false)
                              .updateUser(userData: userData);

                      if (response) {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapScreen()));
                      }
                    })
              ],
            );
          })),
    );
  }
}
