import 'dart:io' show Platform;

import 'package:delivery_kun/components/adBanner.dart';
import 'package:delivery_kun/components/days_hour_bar_chart.dart';
import 'package:delivery_kun/screens/order_list_screen.dart';
import 'package:delivery_kun/screens/sign_up_screen.dart';
import 'package:delivery_kun/services/admob.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:delivery_kun/services/user_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserStatusScreen extends StatefulWidget {
  const UserStatusScreen({Key? key}) : super(key: key);

  @override
  _UserStatusScreenState createState() => _UserStatusScreenState();
}

class _UserStatusScreenState extends State<UserStatusScreen> {

  late AdmobLoad admobLoad;

  @override
  void initState() {
    super.initState();
    admobLoad = AdmobLoad();
    admobLoad.interstitialUserStatus();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('売上履歴'),
        ),
        body: Consumer<Auth>(
            builder: (context, auth, child) => auth.authenticated
                ? LoggedInUserStatus(
                    user_id: auth.user!.id,
                  )
                : const SignUpForm()),
        bottomNavigationBar: const AdBanner());
  }
}

class LoggedInUserStatus extends StatefulWidget {
  LoggedInUserStatus({required this.user_id});

  int user_id;

  @override
  _LoggedInUserStatusState createState() => _LoggedInUserStatusState();
}

class _LoggedInUserStatusState extends State<LoggedInUserStatus> {
  final TextEditingController _actualCostController = TextEditingController();
  late int _actualCostText;
  String validateMessage = '';

  @override
  Widget build(BuildContext context) {
    int user_id = widget.user_id;

    return SingleChildScrollView(
      child: Container(
        child: Consumer<Status>(
            builder: (context, status, child) => status.status != null
                ? Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    context
                                        .read<Status>()
                                        .getStatusBeforeDate(user_id);
                                  },
                                  child: const Icon(Icons.chevron_left)),
                              Text(
                                DateFormat('yyyy年M月d日').format(status.date),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              DateFormat('yyyy年M月d日')
                                          .format(DateTime.now())
                                          .toString() !=
                                      DateFormat('yyyy年M月d日')
                                          .format(status.date)
                                  ? TextButton(
                                      onPressed: () {
                                        Provider.of<Status>(context,
                                                listen: false)
                                            .getStatusNextDate(user_id);
                                      },
                                      child: const Icon(Icons.chevron_right))
                                  : IconButton(
                                      onPressed: () async {
                                        int user_id =
                                            context.read<Auth>().user!.id;
                                        await context
                                            .read<Status>()
                                            .getStatusToday(user_id);
                                        context
                                            .read<Status>()
                                            .getStatusToday(user_id);
                                      },
                                      icon: const Icon(Icons.refresh)),
                            ],
                          )),
                      StatusHourBarChart(data: status.status!.hourQty),
                      Container(
                          margin: const EdgeInsets.only(right: 15, left: 15),
                          child: Column(
                            children: [
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: const Text(
                                    'ステータス',
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  )),
                              Table(
                                  border: const TableBorder(
                                    bottom: BorderSide(
                                        width: 0.5, color: Color(0xFF000000)),
                                  ),
                                  children: [
                                    const TableRow(children: [
                                      Text(
                                        'オンライン',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text('受注数',
                                          style: TextStyle(color: Colors.grey))
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                        child: SizedBox(
                                          height: 50,
                                          child: Text(
                                            status.status!.onlineTime,
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: SizedBox(
                                          height: 50,
                                          child: Text(
                                            status.status!.daysEarningsQty
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ]),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: const Text(
                                    '明細',
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  )),
                              Table(children: [
                                TableRow(children: [
                                  const Text(
                                    '売上',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                      status.status!.daysEarningsTotal
                                          .toString(),
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ))
                                ]),
                                TableRow(children: [
                                  const TableCell(
                                    child: SizedBox(
                                      height: 50,
                                      child: Text(
                                        '支出',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                      child: GestureDetector(
                                    onTap: () {
                                      Platform.isIOS
                                          ? showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CupertinoAlertDialog(
                                                  title: const Text("支出を入力"),
                                                  content: CupertinoTextField(
                                                    controller:
                                                        _actualCostController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                  actions: <Widget>[
                                                    CupertinoDialogAction(
                                                      child:
                                                          const Text("キャンセル"),
                                                      isDestructiveAction: true,
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ),
                                                    CupertinoDialogAction(
                                                      child: const Text("完了",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blueAccent)),
                                                      isDestructiveAction: true,
                                                      onPressed: () async {
                                                        int requestActualCost =
                                                            int.parse(
                                                                _actualCostController
                                                                    .text);

                                                        if (_actualCostController
                                                            .text.isEmpty) {
                                                          showDialog(
                                                              context: context,
                                                              builder: (_) =>
                                                                  AlertWidght(
                                                                      title:
                                                                          '支出を入力してください'));
                                                        } else {
                                                          bool response = await context
                                                              .read<Status>()
                                                              .updateAcutualCost(
                                                                  actualCost:
                                                                      requestActualCost);

                                                          if (response) {
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          } else {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (_) =>
                                                                    AlertWidght(
                                                                        title:
                                                                            'エラーが発生しました'));
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            )
                                          : showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      const Text('支出を入力してください'),
                                                  content: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onChanged: (value) {
                                                      _actualCostText =
                                                          int.parse(value);
                                                    },
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'キャンセル')),
                                                    TextButton(
                                                        onPressed: () async {
                                                          bool response = await context
                                                              .read<Status>()
                                                              .updateAcutualCost(
                                                                  actualCost:
                                                                      _actualCostText);

                                                          if (response) {
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          } else {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (_) =>
                                                                    AlertWidght(
                                                                        title:
                                                                            'エラーが発生しました'));
                                                          }
                                                        },
                                                        child: const Text('完了'))
                                                  ],
                                                );
                                              });
                                    },
                                    child: SizedBox(
                                      height: 50,
                                      child: Text(
                                        status.status!.actualCost.toString(),
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ))
                                ]),
                                TableRow(children: [
                                  const TableCell(
                                    child: SizedBox(
                                      height: 50,
                                      child: Text(
                                        '利益',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: SizedBox(
                                      height: 50,
                                      child: Text(
                                        (status.status!.daysEarningsTotal -
                                                status.status!.actualCost)
                                            .toString(),
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ]),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderListScreen(
                                          date: status.date,
                                        ),
                                        fullscreenDialog: true,
                                      )).then((val) {
                                    context
                                        .read<Status>()
                                        .getStatusDate(user_id);
                                  });
                                },
                                child: const Text(
                                  '受注履歴を見る',
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                  minimumSize: const Size(double.infinity, 55),
                                ),
                              ),
                            ],
                          ))
                    ],
                  )
                : const Center(child: CircularProgressIndicator())),
      ),
    );
  }
}

class AlertWidght extends StatelessWidget {
  AlertWidght({required this.title});

  String title;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      actions: [
        CupertinoDialogAction(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
