import 'package:delivery_kun/components/account_submit_btn.dart';
import 'package:delivery_kun/components/account_text_field.dart';
import 'package:delivery_kun/screens/map_screen.dart';
import 'package:delivery_kun/services/admob.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:delivery_kun/mixins/validate_text.dart';
import 'package:delivery_kun/constants.dart';

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
  late BannerAd _bannerAd;

  List<String> _prefectureList = prefectureList;
  List<String> _VehicleModelList = VehicleModelList;

  @override
  void initState() {
    Auth auth = context.read<Auth>();
    _name = auth.user.name;
    _email = auth.user.email;
    _selectVehicleModelId = auth.user.vehicleModel;
    _selectPrefectureId = auth.user.prefectureId;
    _initBannerAd();
    super.initState();
  }

  Widget vehiceModelIcon(int vehiceModelId) {
    if (vehiceModelId == 0) {
      return Icon(Icons.motorcycle);
    } else if (vehiceModelId == 1) {
      return Icon(Icons.directions_bike);
    } else if (vehiceModelId == 2) {
      return Icon(Icons.directions_car);
    } else {
      return Icon(Icons.directions_walk);
    }
  }

  _initBannerAd() {
    AdmobLoad admobLoad = AdmobLoad();
    _bannerAd = admobLoad.createBarnnerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'ユーザー設定',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            )
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () async{
                Map userData = {
                  'name': _name,
                  'email': _email,
                  'vehicleModelId': _selectVehicleModelId,
                  'prefectureId': _selectPrefectureId+1,
                };
                bool response = await Provider.of<Auth>(context, listen: false).updateUser(userData: userData);

                if (!response) {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text('保存できませんでした',style: TextStyle(color: Colors.black),),
                          actions: [
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              child: Text('OK',style: TextStyle(color: Colors.blueAccent)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapScreen()));
                              },
                            ),
                          ],
                        );
                      });
                }else{
                  Navigator.pop(context);
                }
              },
              child:const Text(
                '更新',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                ),)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.fromLTRB(24, 70, 24, 0),
            child: Consumer<Auth>(builder: (context, auth, _) {
              return auth.user != null ? Column(
                children: [
                  AccountTextField(
                    controller:TextEditingController(text: auth.user.name),
                    obscureText: false,
                    title: 'ユーザ名',
                    icon: Icons.person,
                    isBorder: true,
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
                    controller:TextEditingController(text: auth.user.email),
                    obscureText: false,
                    title: 'メールアドレス',
                    icon: Icons.mail,
                    isBorder: true,
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
                        suffixIcon: vehiceModelIcon(_selectVehicleModelId),
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
                ],
              ):Center(child: CircularProgressIndicator());
            })),
      ),
      bottomNavigationBar:  Container(
        height: _bannerAd.size.height.toDouble(),
        width: _bannerAd.size.width.toDouble(),
        child: AdWidget(ad: _bannerAd),
      ),
    );
  }
}
