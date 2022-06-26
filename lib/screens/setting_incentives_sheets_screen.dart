import 'package:delivery_kun/components/nend_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import 'package:delivery_kun/screens/setting_update_incentives_sheet_screen.dart';
import 'package:delivery_kun/screens/setting_create_incentive_sheet_screen.dart';
import 'package:delivery_kun/screens/map_screen.dart';
import 'package:delivery_kun/services/incentive_sheet.dart';

class SettingIncentivesSheets extends StatefulWidget {
  const SettingIncentivesSheets({Key? key}) : super(key: key);

  @override
  _SettingIncentivesSheetsState createState() => _SettingIncentivesSheetsState();
}

class _SettingIncentivesSheetsState extends State<SettingIncentivesSheets> {
  late List _IncentivesSheetList;
  bool _IsIncentivesSheet = false;

  @override
  void initState() {
    _IncentivesSheetList =  context.read<IncentiveSheet>().IncentivesSheets;
    _IsIncentivesSheet = context.read<IncentiveSheet>().isInsentivesSheet;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('インセンティブ設定'),
        leading: Platform.isAndroid ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MapScreen()));
          },
        ):null,
        actions: [
          IconButton(
              onPressed: () async {
                await context.read<IncentiveSheet>().getIncentives();
              },
              icon: const Icon(Icons.refresh)
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20,),
          SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
                onPressed: (){
                  if(_IncentivesSheetList.length < 8){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const SettingCreateIncentiveScreen())
                    ).then((value) => setState(() {}));
                  }else{
                    showDialog(
                      context: context,
                      builder: (childContext) {
                        return SimpleDialog(
                          title: const Text("8シートまでしか登録できません。"),
                          children: <Widget>[
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(childContext);
                              },
                              child: const Text(
                                "OK",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text(
                  '新規作成',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                )
            ),
          ),
          const SizedBox(height: 20,),
          const Text(
            '保存しているインセンティブシート',
            style: TextStyle(
              color: Colors.grey
            ),
          ),
          Expanded(
            child: _IsIncentivesSheet ? ListView.builder(
              itemCount: _IncentivesSheetList.length,
              itemBuilder: (context, int index) {
                return ListTile(
                  onTap: () async{
                    await context.read<IncentiveSheet>().getIncentive(id: _IncentivesSheetList[index].id);
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingUpdateIncentivesSheetScreen(id: _IncentivesSheetList[index].id,))
                    ).then((value) => setState(() {}));
                  },
                  title: Text(
                    _IncentivesSheetList[index].title,
                    textAlign: TextAlign.center,
                  ),
                  trailing: Icon(Icons.arrow_right),
                );
              }
            ):const Center(child: Text('保存されているインセンティブシートがありません',)),
          ),
        ],
      ),
      bottomNavigationBar: const NendBanner()
    );
  }
}
