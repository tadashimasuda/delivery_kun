import 'package:delivery_kun/components/adBanner.dart';
import 'package:delivery_kun/constants.dart';
import 'package:delivery_kun/models/incentive_sheet.dart';
import 'package:delivery_kun/services/admob.dart';
import 'package:delivery_kun/services/incentive_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingUpdateIncentivesSheetScreen extends StatefulWidget {
  SettingUpdateIncentivesSheetScreen({required this.id});

  String id;

  @override
  _SettingUpdateIncentivesSheetScreenState createState() =>
      _SettingUpdateIncentivesSheetScreenState();
}

class _SettingUpdateIncentivesSheetScreenState
    extends State<SettingUpdateIncentivesSheetScreen> {
  late IncentiveSheetModel IncentivesSheet;
  bool isIncentivesSheet = false;

  TextEditingController TitleContoller = TextEditingController();
  String title = '';
  bool isCreating = false;

  @override
  void initState() {
    IncentivesSheet = context.read<IncentiveSheet>().IncentivesSheet;
    TitleContoller.text = IncentivesSheet.title;
    title = IncentivesSheet.title;

    AdmobLoad admobLoad = AdmobLoad();
    admobLoad.interstitialIncetiveSheeet();

    super.initState();
  }

  SimpleDialog ErrorDialog(BuildContext childContext) {
    return SimpleDialog(
      title: const Text("エラーが発生しました"),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            IncentiveSheet().isError = false;

            Navigator.pop(childContext);
          },
          child: const Text("OK"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('インセンティブ設定'),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  setState(() {
                    isCreating = true;
                  });

                  Map requestBody = {
                    'id': IncentivesSheet.id,
                    'title': title,
                    'earningsIncentives': IncentivesSheet.earningsIncentives
                  };
                  context.read<IncentiveSheet>().updateIncentive(
                      id: IncentivesSheet.id, requestBody: requestBody);

                  bool _isError = await context.read<IncentiveSheet>().isError;
                  if (_isError) {
                    await showDialog(
                        context: context,
                        builder: (childContext) {
                          return ErrorDialog(childContext);
                        });
                  }
                  await context.read<IncentiveSheet>().getIncentives();

                  setState(() {
                    isCreating = false;
                  });

                  Navigator.pop(context);
                },
                child: !isCreating
                    ? const Text(
                        '更新',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      )
                    : Container(
                        width: 20.0,
                        height: 20.0,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        )))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const AdBanner(),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: TitleContoller,
                  autofocus: true,
                  onChanged: (value) {
                    title = value;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                '倍率をタップしてください',
              ),
              const SizedBox(
                height: 20,
              ),
              IncentivesSheet != null
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 17,
                      itemBuilder: (context, int index) {
                        final hour = IncentivesSheet.earningsIncentives.keys
                            .elementAt(index);
                        double incentive = IncentivesSheet
                            .earningsIncentives.values
                            .elementAt(index)
                            .toDouble();

                        return Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 35,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                        hour.toString() + '時',
                                        style: TextStyle(fontSize: 25),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height: 35,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: InkWell(
                                          child: Text(
                                            incentive
                                                    .toStringAsFixed(1)
                                                    .toString() +
                                                "倍",
                                            style: TextStyle(fontSize: 25),
                                            textAlign: TextAlign.center,
                                          ),
                                          onTap: () async {
                                            var result = await showDialog(
                                                context: context,
                                                builder: (childContext) {
                                                  return SimpleDialog(
                                                    title: const Text(
                                                        "インセンティブをタップしてください"),
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                    children: <Widget>[
                                                      for (var i
                                                          in incentiveList)
                                                        Column(
                                                          children: [
                                                            SimpleDialogOption(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    childContext,
                                                                    double
                                                                        .parse(
                                                                            i));
                                                              },
                                                              child: Container(
                                                                  height: 45,
                                                                  width: MediaQuery.of(context)
                                                                          .size
                                                                          .width *
                                                                      0.6,
                                                                  decoration: const BoxDecoration(
                                                                      color: Colors
                                                                          .redAccent,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(20))),
                                                                  child: Center(
                                                                    child: Text(
                                                                      i.toString() +
                                                                          "倍",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            22,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .white,
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
                                            if (result != null) {
                                              setState(() {
                                                IncentivesSheet
                                                        .earningsIncentives[
                                                    '${hour}'] = result;
                                                incentive = result;
                                              });
                                            }
                                          }),
                                    )
                                  ]),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        );
                      })
                  : const Center(child: CircularProgressIndicator()),
              TextButton(
                child: Text('このインセンティブシートを削除する'),
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (childContext) {
                        return SimpleDialog(
                          title: const Text("削除しますか？"),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          children: <Widget>[
                            SimpleDialogOption(
                              onPressed: () async {
                                await context
                                    .read<IncentiveSheet>()
                                    .deleteIncentive(id: IncentivesSheet.id);
                                await context
                                    .read<IncentiveSheet>()
                                    .getIncentives();

                                Navigator.pop(childContext);

                                bool _isError = await context
                                    .read<IncentiveSheet>()
                                    .isError;
                                if (_isError) {
                                  await showDialog(
                                      context: context,
                                      builder: (childContext) {
                                        return ErrorDialog(childContext);
                                      });
                                }

                                Navigator.pop(context);
                              },
                              child: const Text("削除"),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(childContext);
                              },
                              child: const Text("キャンセル"),
                            ),
                          ],
                        );
                      });
                },
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ));
  }
}
