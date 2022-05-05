import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'dart:async';
import 'package:provider/provider.dart';

import 'package:delivery_kun/services/auth.dart';
import 'package:delivery_kun/services/order.dart';
import 'package:delivery_kun/services/user_status.dart';
import 'package:delivery_kun/screens/sign_up_screen.dart';
import 'package:delivery_kun/components/account_submit_btn.dart';

class MapScreenBottomBtn extends StatefulWidget {
  const MapScreenBottomBtn({Key? key}) : super(key: key);

  @override
  _MapScreenBottomBtnState createState() => _MapScreenBottomBtnState();
}

class _MapScreenBottomBtnState extends State<MapScreenBottomBtn> {
  DateTime now = DateTime.now();

  Future<dynamic> IOSDialog() {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('記録しますか？'),
            content: Text('記録時間：${now.hour}時${now.minute}分'),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('キャンセル'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('記録する'),
                onPressed: () async {
                  Auth auth = context.read<Auth>();

                  await OrderList().postOrder();
                  await context.read<Status>().getStatusToday(auth.user!.id);

                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      );
    }

  dynamic AndroidDialog() {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('記録しますか？'),
          content: Text('記録時間：${now.hour}時${now.minute}分'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                print(DateTime.now());
              },
              child: Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                OrderList().postOrder();
                Navigator.pop(context);
              },
              child: Text('記録する'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
            onPressed: (){
              if (context.read<Auth>().authenticated) {
                Platform.isIOS ? IOSDialog() : AndroidDialog();
                setState(() {});
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AlertDialog(
                            title: Text(
                              "デリバリーくんに登録する",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                            ),
                            content: ListBody(
                              children: [
                                ListTile(
                                  title: Text(
                                    '・ワンタッチで配達を記録',
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    '・記録をグラフで確認',
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    '・支出管理もできる',
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  child: SubmitBtn(
                                    title: 'アカウント登録',
                                    color: Colors.lightBlue,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignUpForm()
                                        )
                                      );
                                    },
                                  )
                                )
                              ],
                            ),
                            insetPadding: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                );
              }
            },
              child: Text(
                '受注',
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: Colors.red,
                minimumSize: Size(90, 90),
                elevation: 15,
              ),
            ),
        ],
      ),
    );
  }
}
