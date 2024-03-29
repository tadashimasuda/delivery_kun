import 'package:delivery_kun/components/adBanner.dart';
import 'package:delivery_kun/constants.dart';
import 'package:delivery_kun/screens/setting_incentives_sheets_screen.dart';
import 'package:delivery_kun/services/admob.dart';
import 'package:delivery_kun/services/incentive_sheet.dart';
import 'package:delivery_kun/services/subscription.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingCreateIncentiveScreen extends StatefulWidget {
  const SettingCreateIncentiveScreen({Key? key}) : super(key: key);

  @override
  _SettingCreateIncentiveScreenState createState() =>
      _SettingCreateIncentiveScreenState();
}

class _SettingCreateIncentiveScreenState
    extends State<SettingCreateIncentiveScreen> {
  late Map IncentivesSheet;

  TextEditingController TitleContoller = TextEditingController();
  String title = '';
  bool isCreating = false;
  bool _hasSubscribed = false;

  @override
  void initState() {
    IncentivesSheet = newIncentiveSheet['earningsIncentives'];
    TitleContoller.text = newIncentiveSheet['title'];
    title = newIncentiveSheet['title'];

    _hasSubscribed = context.read<Subscription>().hasSubscribed;
    if (!_hasSubscribed) {
      AdmobLoad admobLoad = AdmobLoad();
      admobLoad.interstitialIncetiveSheeet();
    }

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
                    'title': title,
                    'earningsIncentives':
                        newIncentiveSheet['earningsIncentives']
                  };
                  await context
                      .read<IncentiveSheet>()
                      .postIncentive(requestBody: requestBody);
                  await context.read<IncentiveSheet>().getIncentives();

                  bool _isError = await context.watch<IncentiveSheet>().isError;
                  if (_isError) {
                    await showDialog(
                        context: context,
                        builder: (childContext) {
                          return ErrorDialog(childContext);
                        });
                  }

                  setState(() {
                    isCreating = false;
                  });

                  Navigator.pop(context);
                },
                child: !isCreating
                    ? const Text(
                        '作成',
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
              if (!_hasSubscribed) const AdBanner(),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: TitleContoller,
                  autofocus: true,
                  onChanged: (value) {
                    title = value;
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '倍率をタップしてください',
              ),
              const SizedBox(height: 10),
              IncentivesSheet != null
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 17,
                      itemBuilder: (context, int index) {
                        final hour = newIncentiveSheet['earningsIncentives']
                            .keys
                            .elementAt(index);
                        double incentive =
                            newIncentiveSheet['earningsIncentives']
                                .values
                                .elementAt(index);

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
                                        style: const TextStyle(fontSize: 25),
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
                                            style:
                                                const TextStyle(fontSize: 25),
                                            textAlign: TextAlign.center,
                                          ),
                                          onTap: () async {
                                            double result = await showDialog(
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
                                            setState(() {
                                              newIncentiveSheet[
                                                      'earningsIncentives']
                                                  ["${hour}"] = result;
                                              incentive = result;
                                            });
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
            ],
          ),
        ));
  }
}
