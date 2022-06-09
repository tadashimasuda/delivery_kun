import 'package:delivery_kun/models/incentive_sheet.dart';
import 'package:delivery_kun/services/incentive_sheet.dart';
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async{
              if (context.read<Auth>().authenticated) {
                late List<IncentiveSheetModel>  _IncentivesSheetList = context.read<IncentiveSheet>().IncentivesSheets;

                var sheetId = await showDialog(
                    context: context,
                    builder: (childContext) {
                  return SimpleDialog(
                    title: Text("反映するインセンティブを選択してください"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    children: <Widget>[
                      for (var _IncentivesSheet in _IncentivesSheetList)
                        Column(
                          children: [
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(childContext,_IncentivesSheet.id);
                              },
                              child: Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width * 0.6,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                  BorderRadius.all(
                                      Radius.circular(20)
                                  )
                                ),
                                child: Center(
                                  child: Text(
                                    _IncentivesSheet.title,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                            ),
                            SizedBox(height: 6,)
                          ],
                        ),
                    ],
                  );
                });
                if(sheetId != null){
                  int user_id = context.read<Auth>().user!.id;

                  await context.read<OrderList>().postOrder(sheetId:sheetId);
                  await context.read<Status>().getStatusToday(user_id);
                }
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
