import 'package:delivery_kun/constants.dart';
import 'package:delivery_kun/models/incentive_sheet.dart';
import 'package:delivery_kun/services/incentive_sheet.dart';
import 'package:flutter/material.dart';
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
    return SizedBox(
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              if (context.read<Auth>().authenticated) {
                late List<IncentiveSheetModel> _incentivesSheetList =
                    context.read<IncentiveSheet>().IncentivesSheets;

                var sheetId = await showDialog(
                    context: context,
                    builder: (childContext) {
                      return SimpleDialog(
                        title: const Text("反映するインセンティブを選択してください"),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        children: <Widget>[
                          for (var _incentivesSheet in _incentivesSheetList)
                            Column(
                              children: [
                                SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(
                                        childContext, _incentivesSheet.id);
                                  },
                                  child: Container(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Center(
                                        child: Text(
                                          _incentivesSheet.title,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                ),
                                const SizedBox(
                                  height: 6,
                                )
                              ],
                            ),
                        ],
                      );
                    });

                if (sheetId != null) {
                  int distanceType = await showDialog(
                      context: context,
                      builder: (childContext) {
                        return SimpleDialog(
                          title: const Text("配達距離を選択してください"),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          children: <Widget>[
                            for (String deliveryDistance
                                in deliveryDistanceList)
                              Column(
                                children: [
                                  SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.pop(
                                          childContext,
                                          deliveryDistanceList
                                              .indexOf(deliveryDistance));
                                    },
                                    child: Container(
                                        height: 45,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        decoration: const BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Center(
                                          child: Text(
                                            deliveryDistance,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  )
                                ],
                              ),
                          ],
                        );
                      });
                  if (distanceType != null) {
                    int userId = context.read<Auth>().user!.id;
                    await context.read<OrderList>().postOrder(
                        distanceType: distanceType, sheetId: sheetId);
                    await context.read<Status>().getStatusToday(userId);
                  }
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
                              title: const Text(
                                "デリバリーくんに登録する",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                              content: ListBody(
                                children: [
                                  const ListTile(
                                    title: Text(
                                      '・ワンタッチで配達を記録',
                                    ),
                                  ),
                                  const ListTile(
                                    title: Text(
                                      '・記録をグラフで確認',
                                    ),
                                  ),
                                  const ListTile(
                                    title: Text(
                                      '・支出管理もできる',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  SubmitBtn(
                                    title: 'アカウント登録',
                                    color: Colors.lightBlue,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUpForm()));
                                    },
                                  )
                                ],
                              ),
                              insetPadding: const EdgeInsets.all(20),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                          ],
                        ),
                      );
                    });
              }
            },
            child: const Text(
              '受注',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: Colors.red,
              minimumSize: const Size(90, 90),
              elevation: 15,
            ),
          ),
        ],
      ),
    );
  }
}
