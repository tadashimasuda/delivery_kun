import 'dart:io' show Platform;

import 'package:delivery_kun/components/account_text_field.dart';
import 'package:delivery_kun/components/adBanner.dart';
import 'package:delivery_kun/constants.dart';
import 'package:delivery_kun/mixins/validate_text.dart';
import 'package:delivery_kun/screens/delete_account_screen.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:delivery_kun/services/subscription.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingUserScreen extends StatefulWidget {
  const SettingUserScreen({Key? key}) : super(key: key);

  @override
  _SettingUserScreenState createState() => _SettingUserScreenState();
}

class _SettingUserScreenState extends State<SettingUserScreen>
    with ValidateText {
  late String _name;
  late String _email;
  late int _selectVehicleModelId;
  late int _selectPrefectureId;
  late String _dropdownValue;
  late String _dropdownPrefectureValue;
  final TextEditingController _earningsBaseController = TextEditingController();

  final List<String> _prefectureList = prefectureList;
  final List<String> _vehicleModelList = VehicleModelList;

  bool _hasSubscribed = false;

  @override
  void initState() {
    Auth auth = context.read<Auth>();
    _name = auth.user!.name;
    _email = auth.user!.email;
    _earningsBaseController.text = auth.user!.earningsBase.toString();
    _selectVehicleModelId = auth.user!.vehicleModel;
    _dropdownValue = _vehicleModelList[_selectVehicleModelId];
    _selectPrefectureId = auth.user!.prefectureId;
    _dropdownPrefectureValue = _prefectureList[_selectPrefectureId];

    _hasSubscribed = context.read<Subscription>().hasSubscribed;
    super.initState();
  }

  Widget vehiceModelIcon(int vehiceModelId) {
    if (vehiceModelId == 0) {
      return const Icon(Icons.motorcycle);
    } else if (vehiceModelId == 1) {
      return const Icon(Icons.directions_bike);
    } else if (vehiceModelId == 2) {
      return const Icon(Icons.directions_car);
    } else {
      return const Icon(Icons.directions_walk);
    }
  }

  void IOSPopup() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              '更新できませんでした',
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              'アプリのアップデートをお試しください',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('OK',
                    style: TextStyle(color: Colors.blueAccent)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void AndroidPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('更新できませんでした'),
            content: const Text(
              'アプリのアップデートをお試しください',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  TextField IOSPicker(BuildContext context, Auth auth) {
    return TextField(
      controller:
          TextEditingController(text: _vehicleModelList[_selectVehicleModelId]),
      readOnly: true,
      decoration: InputDecoration(
          labelText: '配達車両',
          suffixIcon: vehiceModelIcon(_selectVehicleModelId),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: CupertinoPicker(
                    itemExtent: 30,
                    onSelectedItemChanged: (val) {
                      setState(() {
                        _selectVehicleModelId = val;
                      });
                    },
                    children: _vehicleModelList.map((e) => Text(e)).toList(),
                    scrollController: FixedExtentScrollController(
                        initialItem: auth.user!.vehicleModel),
                  ));
            });
      },
    );
  }

  DropdownButton<String> AndroidDropDown() {
    return DropdownButton(
      value: _dropdownValue,
      items: _vehicleModelList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? val) {
        setState(() {
          _selectVehicleModelId = _vehicleModelList.indexOf(val!);
          _dropdownValue = _vehicleModelList[_selectVehicleModelId];
        });
      },
      isExpanded: true,
    );
  }

  TextField IOSPrefecturePicker(BuildContext context, Auth auth) {
    return TextField(
      controller:
          TextEditingController(text: _prefectureList[_selectPrefectureId]),
      readOnly: true,
      decoration: InputDecoration(
          hintText: _prefectureList[_selectPrefectureId],
          suffixIcon: const Icon(Icons.location_on),
          labelText: '活動場所',
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: CupertinoPicker(
                  itemExtent: 30,
                  onSelectedItemChanged: (val) {
                    setState(() {
                      _selectPrefectureId = val;
                    });
                  },
                  children: _prefectureList.map((e) => Text(e)).toList(),
                  scrollController: FixedExtentScrollController(
                      initialItem: _selectPrefectureId),
                ),
              );
            });
      },
    );
  }

  DropdownButton<String> AndroidPrefectureDropDown() {
    return DropdownButton(
      value: _dropdownPrefectureValue,
      items: _prefectureList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? val) {
        setState(() {
          _selectPrefectureId = _prefectureList.indexOf(val!);
          _dropdownPrefectureValue = _prefectureList[_selectPrefectureId];
        });
      },
      isExpanded: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ユーザー設定',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  Map userData = {
                    'name': _name,
                    'email': _email,
                    'earningsBase': _earningsBaseController.text,
                    'vehicleModelId': _selectVehicleModelId,
                    'prefectureId': _selectPrefectureId + 1,
                  };
                  bool response =
                      await Provider.of<Auth>(context, listen: false)
                          .updateUser(userData: userData);

                  if (!response) {
                    Platform.isIOS ? IOSPopup() : AndroidPopup();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  '更新',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.fromLTRB(24, 70, 24, 0),
              child: Consumer<Auth>(builder: (context, auth, _) {
                return auth.user != null
                    ? Column(
                        children: [
                          AccountTextField(
                            controller:
                                TextEditingController(text: auth.user!.name),
                            obscureText: false,
                            title: 'ユーザ名',
                            icon: Icons.person,
                            isBorder: Platform.isIOS ? true : false,
                            onChange: (value) {
                              _name = value;
                            },
                          ),
                          Column(
                            children: ValidateUserName(auth.validate_message),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AccountTextField(
                            controller:
                                TextEditingController(text: auth.user!.email),
                            obscureText: false,
                            title: 'メールアドレス',
                            icon: Icons.mail,
                            isBorder: Platform.isIOS ? true : false,
                            onChange: (value) {
                              _email = value;
                            },
                          ),
                          Column(
                            children: ValidateEmail(auth.validate_message),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AccountTextField(
                            controller: _earningsBaseController,
                            obscureText: false,
                            title: '基本報酬(円)',
                            icon: Icons.money,
                            isBorder: Platform.isIOS ? true : false,
                            textInputType: TextInputType.number,
                            onChange: (value) {},
                          ),
                          Column(
                            children:
                                ValidateEarningsBase(auth.validate_message),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Platform.isIOS
                              ? IOSPicker(context, auth)
                              : AndroidDropDown(),
                          Column(
                            children:
                                ValidateVehicleModel(auth.validate_message),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Platform.isIOS
                              ? IOSPrefecturePicker(context, auth)
                              : AndroidPrefectureDropDown(),
                          Column(
                            children: ValidatePrefecture(auth.validate_message),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const DeleteAccountScreen();
                                  },
                                );
                              },
                              child: const Text('アカウント削除'))
                        ],
                      )
                    : const Center(child: CircularProgressIndicator());
              })),
        ),
        bottomNavigationBar: _hasSubscribed != true ? const AdBanner() : null);
  }
}
