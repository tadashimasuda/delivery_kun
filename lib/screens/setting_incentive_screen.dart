import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import 'package:delivery_kun/constants.dart';
import 'package:delivery_kun/services/todayIncentive.dart';
import 'package:delivery_kun/screens/map_screen.dart';

class SettingIncentiveScreen extends StatefulWidget {
  const SettingIncentiveScreen({Key? key}) : super(key: key);

  @override
  _SettingIncentiveScreenState createState() => _SettingIncentiveScreenState();
}

class _SettingIncentiveScreenState extends State<SettingIncentiveScreen> {
  int _selectIncentiveId = 0;
  late List<dynamic>? incentives;
  bool isIncentives = false;

  void getIncentives() {
    incentives = context.read<Incentive>().incentives;
    bool isIncentives = context.read<Incentive>().is_incentives;
    if (isIncentives == false) incentives = incentiveDefault;
  }

  @override
  Widget build(BuildContext context) {
    getIncentives();

    return Scaffold(
      appBar: AppBar(
        leading: Platform.isAndroid
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MapScreen()));
                },
              )
            : null,
        title: const Text('今日のインセンティブ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                context
                    .read<Incentive>()
                    .postTodayIncentive(incentives: incentives);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MapScreen()));
              },
              child: const Text(
                '更新',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Container(
          child: ListView.builder(
              itemCount:
                  isIncentives ? incentives?.length : incentiveDefault.length,
              itemBuilder: (context, int index) {
                return Platform.isIOS
                    ? IOSIncentiveItem(context, index)
                    : AndroidIncentiveItem(index);
              })),
    );
  }

  Widget AndroidIncentiveItem(int index) {
    if (incentives?[index]['earnings_incentive'] is int) {
      incentives?[index]['earnings_incentive'] =
          incentives?[index]['earnings_incentive'].toStringAsFixed(1);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("${incentives?[index]['incentiveHour']}時"),
        DropdownButton(
          value: "${incentives?[index]['earnings_incentive']}",
          items: incentiveList.map((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            );
          }).toList(),
          onChanged: (String? val) {
            setState(() {
              _selectIncentiveId = incentiveList.indexOf(val!);
              incentives?[index]['earnings_incentive'] =
                  incentiveList[_selectIncentiveId];
            });
          },
        ),
      ],
    );
  }

  SizedBox IOSIncentiveItem(BuildContext context, int index) {
    return SizedBox(
        height: 40,
        child: context.read<Incentive>().is_incentives
            ? IncentiveItem(
                index: index,
                incentiveHour: incentives?[index]['incentive_hour'],
                earningsIncentive: incentives?[index]['earnings_incentive'],
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
                                incentives?[index]['earnings_incentive'] =
                                    double.parse(
                                        incentiveList[_selectIncentiveId]);
                              });
                            },
                            children: incentiveList
                                .map((e) => Text(e.toString()))
                                .toList(),
                            scrollController: FixedExtentScrollController(
                              initialItem: incentiveList.indexOf(
                                  incentives![index]['earnings_incentive']
                                      .toString()),
                            ),
                          ),
                        );
                      });
                },
              )
            : IncentiveItem(
                index: index,
                incentiveHour: incentiveDefault[index]['incentive_hour'],
                earningsIncentive: incentiveDefault[index]
                    ['earnings_incentive'],
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          child: CupertinoPicker(
                            itemExtent: 30,
                            onSelectedItemChanged: (val) {
                              setState(() {
                                incentives?[index]['earnings_incentive'] =
                                    double.parse(incentiveList[val]);
                              });
                            },
                            children: incentiveList
                                .map((e) => Text(e.toString()))
                                .toList(),
                            scrollController: FixedExtentScrollController(
                              initialItem: incentiveList.indexOf(
                                  incentives![index]['earnings_incentive']
                                      .toString()),
                            ),
                          ),
                        );
                      });
                },
              ));
  }
}

class IncentiveItem extends StatefulWidget {
  IncentiveItem(
      {required this.index,
      required this.incentiveHour,
      required this.earningsIncentive,
      required this.onTap});

  final int index;
  final String incentiveHour;
  final num earningsIncentive;
  final VoidCallback onTap;

  @override
  _IncentiveItemState createState() => _IncentiveItemState();
}

class _IncentiveItemState extends State<IncentiveItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          Expanded(
            child: Text(widget.incentiveHour.toString() + '時',
                textAlign: TextAlign.center),
          ),
          Expanded(
              child: GestureDetector(
            onTap: widget.onTap,
            child: Text(widget.earningsIncentive.toString()),
          )),
        ],
      ),
    );
  }
}
