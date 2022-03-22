import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:delivery_kun/services/order.dart';
import 'package:delivery_kun/constants.dart';

class OrderUpdateScreen extends StatefulWidget {
  OrderUpdateScreen(
      {required this.id,
      required this.earningsIncentive,
      required this.earningsBase,
      required this.orderReceivedAt});

  int id;
  double earningsIncentive;
  num earningsBase;
  String orderReceivedAt;

  @override
  _OrderUpdateScreenState createState() => _OrderUpdateScreenState(
      id: id,
      earningsIncentive: earningsIncentive,
      earningsBase:earningsBase,
      orderReceivedAt: orderReceivedAt);
}

class _OrderUpdateScreenState extends State<OrderUpdateScreen> {
  _OrderUpdateScreenState(
      {required this.id,
      required this.earningsIncentive,
      required this.earningsBase,
      required this.orderReceivedAt});

  int id;
  double earningsIncentive;
  num earningsBase;
  String orderReceivedAt;

  List<String> _incentiveList = incentiveList;
  late int _selectIncentiveId =
      _incentiveList.indexWhere((val) => val == earningsIncentive.toString());
  int _selectHour = 0;
  int _selectMinite = 0;
  List<int> _hourList = [];
  List<int> _miniteList = [];

  @override
  void initState() {
    DateTime orderReceivedAtParse = DateTime.parse(orderReceivedAt).toLocal();
    _selectHour = orderReceivedAtParse.hour;
    _selectMinite = orderReceivedAtParse.minute;
    for (int h = 0; h < 24; h++) {
      _hourList.add(h);
    }
    for (int m = 0; m < 60; m++) {
      _miniteList.add(m);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var incentiveController = TextEditingController();
    var baseController = TextEditingController();
    baseController.text = earningsBase.toString();

    return Scaffold(
        appBar: AppBar(
          title: const Text('編集画面'),
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
                                _selectMinite.toString() +
                                '分'),
                        readOnly: true,
                        onTap: () {
                          showModalBottomSheet(
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
                                    Expanded(child: Text('時')),
                                    Expanded(
                                        child: CupertinoPicker(
                                      itemExtent: 30,
                                      onSelectedItemChanged: (val) {
                                        setState(() {
                                          _selectMinite = val;
                                        });
                                      },
                                      children: _miniteList
                                          .map((e) => Text(e.toString()))
                                          .toList(),
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem: _selectMinite),
                                    )),
                                    Expanded(child: Text('分')),
                                  ],
                                );
                              });
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
                  TableRow(children: [
                    UpdateTitleCell(title: 'インセンティブ'),
                    TableCell(
                      child: TextField(
                          controller: TextEditingController(
                              text: _incentiveList[_selectIncentiveId]
                                  .toString()),
                          readOnly: true,
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height:
                                        MediaQuery.of(context).size.height / 3,
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
                          }),
                    )
                  ])
                ],
              ),
              SizedBox(height: 30,),
              TextButton(
                  onPressed: () async {
                    String time = orderReceivedAt.substring(0, 10) +
                        ' ' +
                        _selectHour.toString().padLeft(2, "0") +
                        ':' +
                        _selectMinite.toString().padLeft(2, "0") +
                        ':00';
                    Map requestData = {
                      'earnings_incentive': _incentiveList[_selectIncentiveId],
                      'earnings_base': baseController.text,
                      'update_date_time': time
                    };

                    bool response =
                        await Provider.of<OrderList>(context, listen: false)
                            .updateOrder(requestData: requestData, id: id);

                    if (response) {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text(
                                '更新されました！',
                                style: TextStyle(color: Colors.black),
                              ),
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
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.grey)),
                    child: GestureDetector(
                      child: const Center(
                            child: Text(
                              '編集完了',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                    ),
                  ))
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
  }
}
