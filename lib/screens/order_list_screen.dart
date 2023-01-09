import 'dart:io' show Platform;

import 'package:delivery_kun/components/ad_banner.dart';
import 'package:delivery_kun/constants.dart';
import 'package:delivery_kun/screens/order_update_screen.dart';
import 'package:delivery_kun/services/order.dart';
import 'package:delivery_kun/services/subscription.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderListScreen extends StatefulWidget {
  OrderListScreen({required this.date});

  final DateTime date;

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  String getJPDate(DateTime createdAt) {
    initializeDateFormatting('ja');
    return DateFormat.Hm('ja').format(createdAt.toLocal()).toString();
  }

  void reloadWidget() {
    String date = DateFormat('yyyyMMdd').format(widget.date).toString();
    context.read<OrderList>().getOrders(date);
  }

  void iosPopUp(int id, num earningsIncentive, num earningsBase,
      int? distanceType, String orderReceivedAt) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('編集'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderUpdateScreen(
                        id: id,
                        earningsIncentive:
                            double.parse(earningsIncentive.toString()),
                        earningsBase: earningsBase,
                        distanceType: distanceType ?? -1,
                        orderReceivedAt: orderReceivedAt),
                    fullscreenDialog: true,
                  )).then((val) {
                reloadWidget();
              });
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('削除'),
            onPressed: () {
              Navigator.pop(context);
              showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                        title: const Text(
                          '削除しますか？',
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: const Text(
                              '削除',
                              style: TextStyle(color: Colors.lightBlue),
                            ),
                            onPressed: () async {
                              bool response = await Provider.of<OrderList>(
                                      context,
                                      listen: false)
                                  .deleteOrder(id: id);
                              if (response) {
                                Navigator.pop(context);
                                reloadWidget();
                              } else {
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) =>
                                        iosAlertDialog(context));
                              }
                            },
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: const Text(
                              'キャンセル',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ));
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text(
            "キャンセル",
            style: TextStyle(color: Colors.redAccent),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void androidPopUp(int id, num earningsIncentive, num earningsBase,
      int? distanceType, String orderReceivedAt) {
    showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('選択してください'),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text(
                '編集する',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderUpdateScreen(
                          id: id,
                          earningsIncentive:
                              double.parse(earningsIncentive.toString()),
                          earningsBase: earningsBase,
                          distanceType: distanceType ?? -1,
                          orderReceivedAt: orderReceivedAt),
                      fullscreenDialog: true,
                    )).then((val) {
                  reloadWidget();
                });
              },
            ),
            SimpleDialogOption(
              child: const Text(
                '削除する',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                bool response =
                    await Provider.of<OrderList>(context, listen: false)
                        .deleteOrder(id: id);

                if (response) {
                  Navigator.pop(context);
                  reloadWidget();
                } else {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return androidAlertDialog(context);
                      });
                }
              },
            ),
            SimpleDialogOption(
              child: const Text(
                'キャンセル',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  AlertDialog androidAlertDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('更新できませんでした'),
      content: const Text('もう一度お試しください'),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  CupertinoAlertDialog iosAlertDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(
        'エラーが発生しました',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.lightBlue),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            reloadWidget();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    reloadWidget();
    bool _isSubscribed = context.watch<Subscription>().hasSubscribed;

    return Scaffold(
      appBar: AppBar(
        leading: Platform.isAndroid
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        title: Text(DateFormat('M月d日').format(widget.date).toString()),
      ),
      body: Column(
        children: [
          if (!_isSubscribed) const AdBanner(),
          const SizedBox(
            height: 20,
          ),
          const Text('タップで編集・削除ができます'),
          Consumer<OrderList>(
              builder: (context, orderList, child) => orderList.orders != null
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: orderList.orders?.length,
                          itemBuilder: (context, int index) {
                            return SizedBox(
                              height: 55,
                              child:
                                  _orderItem(orderList.orders?[index], index),
                            );
                          }),
                    )
                  : const Center(child: CircularProgressIndicator()))
        ],
      ),
    );
  }

  Widget _orderItem(var order, int index) {
    num earningsIncentive = order['earnings_incentive'];
    num earningsTotal = order['earnings_total'];
    num earningsBase = order['earnings_base'];
    int? distanceType = order['earnings_distance_base_type'];
    String orderReceivedAt = order['order_received_at'].toString();

    return InkWell(
      onTap: () {
        Platform.isIOS
            ? iosPopUp(order['id'], earningsIncentive, earningsBase,
                distanceType, orderReceivedAt)
            : androidPopUp(order['id'], earningsIncentive, earningsBase,
                distanceType, orderReceivedAt);
      },
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${index + 1}',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(getJPDate(DateTime.parse(order['order_received_at'])),
                textAlign: TextAlign.center),
          ),
          distanceType != null
              ? Expanded(
                  child: Text(
                    deliveryDistanceList[distanceType],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              : const SizedBox(),
          Expanded(
            child: Text('×${double.parse(earningsIncentive.toString())}',
                textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text('¥${earningsTotal.toString()}',
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
