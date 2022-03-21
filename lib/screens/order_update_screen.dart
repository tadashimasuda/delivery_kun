import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:delivery_kun/services/order.dart';

class OrderUpdateScreen extends StatefulWidget {
  OrderUpdateScreen(
      {required this.id,
      required this.earningsIncentive,
      required this.createdAt});

  int id;
  num earningsIncentive;
  String createdAt;

  @override
  _OrderUpdateScreenState createState() => _OrderUpdateScreenState(
      id: id, earningsIncentive: earningsIncentive, createdAtString: createdAt);
}

class _OrderUpdateScreenState extends State<OrderUpdateScreen> {
  _OrderUpdateScreenState(
      {required this.id,
      required this.earningsIncentive,
      required this.createdAtString});

  int id;
  num earningsIncentive;
  String createdAtString;

  final List<String> _incentiveList = [
    '1.0',
    '1.1',
    '1.2',
    '1.3',
    '1.4',
    '1.5',
    '1.6',
    '1.7',
    '1.8',
    '1.9',
    '2.0',
  ];

  late int _selectIncentiveId = _incentiveList.indexWhere((val) => val == earningsIncentive.toString());
  late DateTime _selectDateTime = DateTime.parse(createdAtString);

  @override
  Widget build(BuildContext context) {
    DateTime createdAt = DateTime.parse(createdAtString);

    var incentiveController = TextEditingController();
    var baseController = TextEditingController();
    baseController.text = '715';

    return Scaffold(
        appBar: AppBar(
          title: const Text('編集画面'),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
          child: Column(
            children:[
              Table(
                children: [
                  TableRow(children: [
                    UpdateTitleCell(
                        title:'受注時間'
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: TextField(
                        controller: TextEditingController(text: DateFormat('hh時mm分').format(_selectDateTime).toString()),
                        readOnly: true,
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: MediaQuery.of(context).size.height / 3,
                                  child: CupertinoDatePicker(
                                    initialDateTime:createdAt,
                                    mode: CupertinoDatePickerMode.time,
                                    onDateTimeChanged: (dateTime) {
                                      setState(() {
                                        _selectDateTime = dateTime;
                                      });
                                    },
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    UpdateTitleCell(
                        title:'報酬ベース'
                    ),
                    TableCell(
                      child: TextField(
                        controller: baseController,
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ]),
                  TableRow(children: [
                    UpdateTitleCell(
                        title:'インセンティブ'
                    ),
                    TableCell(
                      child: TextField(
                          controller: TextEditingController(text:_incentiveList[_selectIncentiveId].toString()),
                          readOnly: true,
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
                                          _selectIncentiveId = val;
                                          incentiveController.text = _incentiveList[val].toString();
                                        });
                                      },
                                      children: _incentiveList
                                          .map((e) => Text(e))
                                          .toList(),
                                      scrollController: FixedExtentScrollController(
                                          initialItem: _selectIncentiveId),
                                    ),
                                  );
                                });
                          }),
                    )
                  ])
                ],
              ),
              TextButton(
                  onPressed: () async{
                    Map requestData = {
                      'earnings_incentive':_incentiveList[_selectIncentiveId],
                      'earnings_base':baseController.text,
                      'date_time':_selectDateTime.toString().substring(0,19),
                    };

                    bool response = await Provider.of<OrderList>(context, listen: false).updateOrder(requestData: requestData,id: id);
                    if (response) {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text('更新されました！',style: TextStyle(color: Colors.black),),
                              actions: [
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                    }
                  },
                  child: GestureDetector(
                      child: Container(
                          margin: EdgeInsets.only(top: 30),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.grey)),
                          child: const Center(
                            child: Text(
                              '編集完了',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                      )
                  )
              )
            ],
          ),
        ));
  }
}

class UpdateTitleCell extends StatelessWidget {
  UpdateTitleCell({required this.title});

  String title;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold
        ),
      )
    );
  }
}