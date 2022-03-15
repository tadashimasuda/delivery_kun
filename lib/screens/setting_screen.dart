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
  int _selectVehicleModelId = 1;
  int _selectPrefectureId = 1;

  List<String> _prefectureList = ['東京', '埼玉', '栃木'];
  List<String> _VehicleModelList = ['バイク', '自転車', '車', '徒歩'];

  @override
  void initState() {
    Auth auth = context.read<Auth>();
    String _name = auth.user.name;
    String _email = auth.user.email;
    _selectVehicleModelId = auth.user.vehicleModel;
    _selectPrefectureId = auth.user.prefectureId;
    super.initState();
  }

  Widget vehiceModelIcon(int vehiceModelId){
    if(vehiceModelId ==0) {
      return Icon(Icons.directions_car);
    }else if(vehiceModelId==1){
      return Icon(Icons.directions_bike);
    }else if(vehiceModelId==2){
      return Icon(Icons.motorcycle);
    }else{
      return Icon(Icons.directions_walk);
    }
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
                      text: _VehicleModelList[_selectVehicleModelId]),
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: '配達車両',
                      suffixIcon:vehiceModelIcon(_selectVehicleModelId),
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
                                  _selectVehicleModelId = val;
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
                      text: _prefectureList[_selectPrefectureId]),
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: _prefectureList[_selectPrefectureId],
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
                                  _selectPrefectureId = val;
                                });
                              },
                              children:
                                  _prefectureList.map((e) => Text(e)).toList(),
                              scrollController: FixedExtentScrollController(
                                  initialItem: _selectPrefectureId),
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
                        'prefectureId': _selectPrefectureId,
                        'vehicleModelId': _selectVehicleModelId
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
