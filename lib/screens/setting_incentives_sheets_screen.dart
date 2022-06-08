import 'package:delivery_kun/screens/setting_incentives_sheet_screen.dart';
import 'package:delivery_kun/services/incentive_sheet.dart';
import 'package:flutter/material.dart';
import 'package:delivery_kun/constants.dart';
import 'package:provider/provider.dart';

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
    super.initState();
    _IncentivesSheetList =  context.read<IncentiveSheet>().IncentivesSheets;
    _IsIncentivesSheet = context.read<IncentiveSheet>().isInsentivesSheet;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('インセンティブ設定'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
                onPressed: (){},
                child: Text('新規作成')
            ),
          ),
          SizedBox(height: 20,),
          Text(
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
                        MaterialPageRoute(builder: (context) => SettingIncentivesSheetScreen(id: _IncentivesSheetList[index].id,)));
                  },
                  title: Text(
                    _IncentivesSheetList[index].title,
                    textAlign: TextAlign.center,
                  ),
                  trailing: Icon(Icons.arrow_right),
                );
              }
            ):Center(child: Text('保存されているインセンティブシートがありません',)),
          ),
        ],
      )
    );
  }
}
