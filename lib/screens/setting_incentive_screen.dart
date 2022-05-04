import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:delivery_kun/constants.dart';

import 'package:delivery_kun/services/todayIncentive.dart';

class SettingIncentiveScreen extends StatefulWidget {
  const SettingIncentiveScreen({Key? key}) : super(key: key);

  @override
  _SettingIncentiveScreenState createState() => _SettingIncentiveScreenState();
}

class _SettingIncentiveScreenState extends State<SettingIncentiveScreen> {

  int _selectIncentiveId = 0;
  late List<dynamic>? incentives;

  @override
  void initState() {
    context.read<Incentive>().getTodayIncentive();
    incentives = context.read<Incentive>().incentives;
    if(incentives == null) incentives = incentiveDefault;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '今日のインセンティブ',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          )
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async{
              context.read<Incentive>().postTodayIncentive(incentives: incentives);
              Navigator.pop(context);
            },
            child:const Text(
              '更新',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold
              ),
            )
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: context.read<Incentive>().is_incentives ? incentives?.length:incentiveDefault.length,
          itemBuilder: (context, int index) {
            return Container(
              height: 40,
              child:context.read<Incentive>().is_incentives ?
              IncentiveItem(
                index: index,
                incentive_hour: incentives?[index]['incentive_hour'],
                earnings_incentive: incentives?[index]['earnings_incentive'],
                onTap: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: CupertinoPicker(
                          itemExtent: 30,
                          onSelectedItemChanged: (val) {
                            setState(() {
                              _selectIncentiveId = val;
                              incentives?[index]['earnings_incentive'] = double.parse(incentiveList[_selectIncentiveId]);
                            });
                          },
                          children: incentiveList.map((e) => Text(e.toString())).toList(),
                          scrollController: FixedExtentScrollController(
                              initialItem: incentiveList.indexOf(incentives![index]['earnings_incentive'].toString()),
                          ),
                        ),
                      );
                    }
                  );
                },
              ):
              IncentiveItem(
                index: index,
                incentive_hour: incentiveDefault[index]['incentive_hour'],
                earnings_incentive: incentiveDefault[index]['earnings_incentive'],
                onTap: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: CupertinoPicker(
                          itemExtent: 30,
                          onSelectedItemChanged: (val) {
                            setState(() {
                              incentives?[index]['earnings_incentive'] = double.parse(incentiveList[val]);
                            });
                          },
                          children: incentiveList.map((e) => Text(e.toString())).toList(),
                          scrollController: FixedExtentScrollController(
                            initialItem: incentiveList.indexOf(incentives![index]['earnings_incentive'].toString()),
                          ),
                        ),
                      );
                    }
                  );
                },
              )
            );
          }
        )
      ),
    );
  }
}
class IncentiveItem extends StatefulWidget {
  IncentiveItem({
    required this.index,
    required this.incentive_hour,
    required this.earnings_incentive,
    required this.onTap
  });

  final int index;
  final String incentive_hour;
  final num earnings_incentive;
  final VoidCallback onTap;

  @override
  _IncentiveItemState createState() => _IncentiveItemState();
}

class _IncentiveItemState extends State<IncentiveItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          Expanded(
            child: Container(
                child: Text(
                    widget.incentive_hour.toString() + '時',
                    textAlign: TextAlign.center
                )
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: widget.onTap,
              child: Text(widget.earnings_incentive.toString()),
            )
          ),
        ],
      ),
    );
  }
}