import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:delivery_kun/services/admob.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:delivery_kun/services/user_status.dart';
import 'package:delivery_kun/screens/order_list.dart';
import 'package:delivery_kun/screens/sign_up_screen.dart';
import 'package:delivery_kun/components/days_hour_bar_chart.dart';

class UserStatusScreen extends StatefulWidget {
  const UserStatusScreen({Key? key}) : super(key: key);

  @override
  _UserStatusScreenState createState() => _UserStatusScreenState();
}

class _UserStatusScreenState extends State<UserStatusScreen> {
  late BannerAd _bannerAd;

  _initBannerAd() {
    AdmobLoad admobLoad = AdmobLoad();
    _bannerAd = admobLoad.createBarnnerAd();
  }

  @override
  void initState() {
    _initBannerAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('売上履歴'),
      ),
      body: Consumer<Auth>(
          builder: (context, auth, child) => auth.authenticated
              ? LoggedInUserStatus(
                  user_id: auth.user.id,
                )
              : SignUpForm()),
      bottomNavigationBar:  Container(
        height: _bannerAd.size.height.toDouble(),
        width: _bannerAd.size.width.toDouble(),
        child: AdWidget(ad: _bannerAd),
      ),
    );
  }
}

class LoggedInUserStatus extends StatefulWidget {
  LoggedInUserStatus({required this.user_id});

  int user_id;

  @override
  _LoggedInUserStatusState createState() => _LoggedInUserStatusState();
}

class _LoggedInUserStatusState extends State<LoggedInUserStatus> {
  var actualCost = TextEditingController();
  String validateMessage = '';

  @override
  Widget build(BuildContext context) {
    context.read<Status>().getStatusToday(widget.user_id);
    return SingleChildScrollView(
      child: Container(
        child: Consumer<Status>(
            builder: (context, status, child) => status.status != null
                ? Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Provider.of<Status>(context, listen: false).getStatusBeforeDate(widget.user_id);
                                  },
                                  child: Icon(Icons.chevron_left)),
                              Text(
                                DateFormat('yyyy年M月d日').format(status.date),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              DateFormat('yyyy年M月d日')
                                          .format(DateTime.now())
                                          .toString() !=
                                      DateFormat('yyyy年M月d日').format(status.date)
                                  ? TextButton(
                                      onPressed: () {
                                        Provider.of<Status>(context,
                                                listen: false)
                                            .getStatusNextDate(widget.user_id);
                                      },
                                      child: Icon(Icons.chevron_right))
                                  : TextButton(onPressed: () {}, child: Text('')),
                            ],
                          )),
                      StatusHourBarChart(data: status.status.hourQty),
                      Container(
                          margin: EdgeInsets.only(right: 15, left: 15),
                          child: Column(
                            children: [
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    'ステータス',
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  )),
                              Table(
                                  border: TableBorder(
                                    bottom: BorderSide(
                                        width: 0.5, color: Color(0xFF000000)),
                                  ),
                                  children: [
                                    TableRow(children: [
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
                                            status.status.onlineTime,
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
                                            status.status.daysEarningsQty.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ]),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    '明細',
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  )),
                              Table(children: [
                                TableRow(children: [
                                  Text(
                                    '売上',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                      status.status.daysEarningsTotal.toString(),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ))
                                ]),
                                TableRow(children: [
                                  TableCell(
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
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text("支出を入力"),
                                            content: CupertinoTextField(
                                              controller: actualCost,
                                              keyboardType: TextInputType.number,
                                            ),
                                            actions: <Widget>[
                                              CupertinoDialogAction(
                                                child: Text("キャンセル"),
                                                isDestructiveAction: true,
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                              CupertinoDialogAction(
                                                child: Text("完了",style: TextStyle(color: Colors.blueAccent)),
                                                isDestructiveAction: true,
                                                onPressed: () async {
                                                  int requestActualCost = int.parse(actualCost.text);

                                                  if (actualCost.text.isEmpty) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) => AlertWidght(title:'支出を入力してください')
                                                    );
                                                  } else {
                                                    bool response = await Provider.of<Status>(context, listen: false).updateAcutualCost(actualCost: requestActualCost);

                                                    if (response) {
                                                      Navigator.pop(context);
                                                      setState(() {});
                                                    }else{
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) => AlertWidght(title: 'エラーが発生しました'));
                                                    }
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: SizedBox(
                                      height: 50,
                                      child: Text(
                                        status.status.actualCost.toString(),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ))
                                ]),
                                TableRow(children: [
                                  TableCell(
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
                                        (status.status.daysEarningsTotal - status.status.actualCost).toString(),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
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
                                          userId: 1,
                                          date: status.date,
                                        ),
                                        fullscreenDialog: true,
                                      )).then((val) {
                                    Provider.of<Status>(context, listen: false).getStatusDate(widget.user_id);
                                  });
                                },
                                child: Text(
                                  '受注履歴を見る',
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                  minimumSize: Size(double.infinity, 55),
                                ),
                              ),
                            ],
                          ))
                    ],
                  )
                : Center(child: CircularProgressIndicator())),
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

