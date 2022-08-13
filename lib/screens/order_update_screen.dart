import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import 'package:delivery_kun/services/order.dart';
import 'package:delivery_kun/constants.dart';

class OrderUpdateScreen extends StatefulWidget {
  OrderUpdateScreen(
      {required this.id,
      required this.earningsIncentive,
      required this.earningsBase,
        required this.distanceType,
      required this.orderReceivedAt});

  int id;
  double earningsIncentive;
  num earningsBase;
  int distanceType;
  String orderReceivedAt;

  @override
  _OrderUpdateScreenState createState() => _OrderUpdateScreenState(
      id: id,
      earningsIncentive: earningsIncentive,
      earningsBase:earningsBase,
      distanceType:distanceType,
      orderReceivedAt: orderReceivedAt);
}

class _OrderUpdateScreenState extends State<OrderUpdateScreen> {
  _OrderUpdateScreenState(
      {required this.id,
      required this.earningsIncentive,
      required this.earningsBase,
      required this.distanceType,
      required this.orderReceivedAt});

  int id;
  double earningsIncentive;
  num earningsBase;
  int distanceType;
  String orderReceivedAt;

  final List<String> _incentiveList = incentiveList;
  late int _selectIncentiveId =
      _incentiveList.indexWhere((val) => val == earningsIncentive.toString());
  int _selectHour = 0;
  int _selectMinute = 0;
  final List<int> _hourList = [];
  final List<int> _minuteList = [];

  TextEditingController incentiveController = TextEditingController();
  TextEditingController distanceTypeController = TextEditingController();
  TextEditingController baseController = TextEditingController();

  @override
  void initState() {
    DateTime orderReceivedAtParse = DateTime.parse(orderReceivedAt).toLocal();
    _selectHour = orderReceivedAtParse.hour;
    _selectMinute = orderReceivedAtParse.minute;
    for (int h = 0; h < 24; h++) {
      _hourList.add(h);
    }
    for (int m = 0; m < 60; m++) {
      _minuteList.add(m);
    }
    baseController.text = earningsBase.toString();
    super.initState();
  }

  Future _androidSelectTime(BuildContext context) async {
   final initialTime = TimeOfDay(hour: _selectHour, minute: _selectMinute);

   final newTime = await showTimePicker(context: context, initialTime: initialTime);

   if(newTime != null){
     setState(() {
       _selectHour = newTime.hour;
       _selectMinute = newTime.minute;
     });
   }else{
     return;
   }
  }

  Future _iOSSelectTime(){
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Row(
          children: [
            Expanded(
              child: CupertinoPicker(
                itemExtent: 30,
                onSelectedItemChanged: (val) {
                  setState(() {
                    _selectHour = val;
                  });
                },
                children: _hourList
                    .map((e) => Text(e.toString()))
                    .toList(),
                scrollController:
                FixedExtentScrollController(
                    initialItem: _selectHour),
              )),
            const Expanded(child: Text('時')),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 30,
                onSelectedItemChanged: (val) {
                  setState(() {
                    _selectMinute = val;
                  });
                },
                children: _minuteList.map((e) =>
                    Text(e.toString())
                ).toList(),
                scrollController:
                FixedExtentScrollController(
                    initialItem: _selectMinute),
              )),
            const Expanded(child: Text('分')),
          ],
        );
      });
  }

  Widget iosIncentiveTextForm(){
    return TextField(
        controller: TextEditingController(
            text: _incentiveList[_selectIncentiveId]
                .toString()
        ),
        readOnly: true,
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
                        _selectIncentiveId = val;
                        incentiveController.text =
                            _incentiveList[val].toString();
                      });
                    },
                    children: _incentiveList
                        .map((e) => Text(e))
                        .toList(),
                    scrollController:
                    FixedExtentScrollController(
                        initialItem: _selectIncentiveId),
                  ),
                );
              });
        });
  }
  Widget iosDeliveryDistanceForm(){
    return TextField(
        controller: TextEditingController(
            text: deliveryDistanceList[distanceType].toString()
        ),
        readOnly: true,
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
                        distanceType = val;
                        distanceTypeController.text =
                            deliveryDistanceList[val].toString();
                      });
                    },
                    children: deliveryDistanceList
                        .map((e) => Text(e))
                        .toList(),
                    scrollController:
                    FixedExtentScrollController(
                        initialItem: distanceType),
                  ),
                );
              });
        });
  }

  DropdownButton androidIncentiveTextForm(){
    return DropdownButton(
      value: _incentiveList[_selectIncentiveId],
      items: _incentiveList.map((e) {
        return DropdownMenuItem<String>(
          value: e,
          child: Text(e),
        );
      }).toList(),
      onChanged: (val){
        setState(() {
          _selectIncentiveId = incentiveList.indexOf(val);
        });
      },
    );
  }

  DropdownButton androidDeliveryDistanceForm(){
    return DropdownButton(
      value: deliveryDistanceList[distanceType],
      items: deliveryDistanceList.map((e) {
        return DropdownMenuItem<String>(
          value: e,
          child: Text(e),
        );
      }).toList(),
      onChanged: (val){
        setState(() {
          distanceType = deliveryDistanceList.indexOf(val);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '編集画面',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
          actions:<Widget> [
            TextButton(
              onPressed: () async {
                String time = orderReceivedAt.substring(0, 10) +
                    ' ' + _selectHour.toString().padLeft(2, "0") +
                    ':' + _selectMinute.toString().padLeft(2, "0") +
                    ':00';

                Map requestData = {
                  'earnings_incentive': _incentiveList[_selectIncentiveId],
                  'earnings_base': baseController.text,
                  'update_date_time': time
                };

                if(distanceType != -1){
                  requestData.addAll(
                    {'earnings_distance_base_type' : distanceType}
                  );
                }

                bool response =
                await Provider.of<OrderList>(context, listen: false)
                    .updateOrder(requestData: requestData, id: id);

                if (!response) {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text(
                          'エラーが発生しました',
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: const Text('OK',style: TextStyle(color: Colors.blueAccent)),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
                }else{
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
                },
              child: const Text(
                '完了',
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
          padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
          child: Column(
            children: [
              Table(
                children: [
                  TableRow(children: [
                    UpdateTitleCell(title: '受注時間'),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: TextField(
                        controller: TextEditingController(
                          text: _selectHour.toString() +
                              '時' +
                              _selectMinute.toString() +
                              '分'),
                        readOnly: true,
                        onTap: () {
                          Platform.isIOS ? _iOSSelectTime():_androidSelectTime(context);
                        },
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    UpdateTitleCell(title: '報酬ベース'),
                    TableCell(
                      child: TextField(
                        controller: baseController,
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ]),
                  TableRow(
                    children: [
                      UpdateTitleCell(title: 'インセンティブ'),
                      TableCell(
                        child: Platform.isIOS ? iosIncentiveTextForm() : androidIncentiveTextForm()
                      )
                    ]
                  ),
                  if(distanceType != -1)
                    TableRow(
                        children: [
                          UpdateTitleCell(title: '距離選択'),
                          TableCell(
                              child: Platform.isIOS ? iosDeliveryDistanceForm() : androidDeliveryDistanceForm()
                          )
                        ]
                    )
                ],
              ),
              const SizedBox(height: 30,),
            ],
          ),
        ));
  }
}

class UpdateTitleCell extends StatelessWidget {
  UpdateTitleCell({Key? key, required this.title}) : super(key: key);

  String title;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      )
    );
  }
}
