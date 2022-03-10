import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'order_list.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:delivery_kun/services/user_status.dart';

class UserStatusScreen extends StatefulWidget {
  const UserStatusScreen({Key? key}) : super(key: key);

  @override
  _UserStatusScreenState createState() => _UserStatusScreenState();
}

class _UserStatusScreenState extends State<UserStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('売り上げ履歴'),
      ),
      body: Consumer<Auth>(
          builder: (context, auth, child) => auth.authenticated
              ? LoggedInUserStatus(
                  user_id: auth.user.id,
                )
              : NotLoginUserstatus()),
    );
  }
}

class NotLoginUserstatus extends StatelessWidget {
  const NotLoginUserstatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('ログインはこちら'),
    );
  }
}

class LoggedInUserStatus extends StatelessWidget {
  LoggedInUserStatus({required this.user_id});

  int user_id;

  @override
  Widget build(BuildContext context) {
    context.read<Status>().getStatus(user_id);
    return Container(
      child: Consumer<Status>(
        builder: (context, status, child) => Column(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  DateFormat('yyyy年M月d日').format(DateTime.now()),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
            Container(
              height: 250,
              color: Colors.grey,
            ),
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
                          bottom:
                              BorderSide(width: 0.5, color: Color(0xFF000000)),
                        ),
                        children: [
                          TableRow(children: [
                            Text(
                              'オンライン',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text('受注数', style: TextStyle(color: Colors.grey))
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: SizedBox(
                                height: 50,
                                child: Text(
                                  status.status?.onlineTime ?? 'a',
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
                                  status.status?.daysEarningsQty.toString()?? 'a',
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
                        Text(status.status?.daysEarningsTotal.toString()?? 'a',
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
                          child: SizedBox(
                            height: 50,
                            child: Text(
                              status.status?.actualCost.toString()?? 'a',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ]),
                      // TableRow(children: [
                      //   TableCell(
                      //     child: SizedBox(
                      //       height: 50,
                      //       child: Text(
                      //         '利益',
                      //         style: TextStyle(
                      //           fontSize: 20,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      //   TableCell(
                      //     child: SizedBox(
                      //       height: 50,
                      //       child: Text(
                      //         (status.status!.daysEarningsTotal -
                      //                 status.status!.actualCost)
                      //             .toString(),
                      //         textAlign: TextAlign.right,
                      //         style: TextStyle(
                      //           fontSize: 20,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ]),
                    ]),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderList(),
                              fullscreenDialog: true,
                            ));
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
        ),
      ) ,
    );
  }
}
