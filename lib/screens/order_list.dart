import 'package:delivery_kun/screens/order_update_screen.dart';
import 'package:delivery_kun/services/admob.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:delivery_kun/services/order.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class OrderListScreen extends StatefulWidget {
  OrderListScreen({required this.date});

  final DateTime date;

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late BannerAd _bannerAd;

  _initBannerAd() {
    AdmobLoad admobLoad = AdmobLoad();
    _bannerAd = admobLoad.createBarnnerAd();
  }

  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  String getJPDate(DateTime createdAt) {
    initializeDateFormatting('ja');
    return DateFormat.Hm('ja').format(createdAt.toLocal()).toString();
  }

  void reloadWidget() {
    String date = DateFormat('yyyyMMdd').format(widget.date).toString();
    context.read<OrderList>().getOrders(date);
  }

  @override
  Widget build(BuildContext context) {
    reloadWidget();
    return Scaffold(
        appBar: AppBar(
          title: Text(DateFormat('M月d日').format(widget.date).toString()),
        ),
        body: Consumer<OrderList>(
            builder: (context, orderList, child) => orderList.orders != null
                ? Container(
                    child: orderList == null
                        ? Text(' ')
                        : ListView.builder(
                            itemCount: orderList.orders?.length,
                            itemBuilder: (context, int index) {
                              return Container(
                                height: 55,
                                child:
                                    _orderItem(orderList.orders?[index], index),
                              );
                            }),
                  )
                : Center(child: CircularProgressIndicator())),
        bottomNavigationBar:  Container(
          height: _bannerAd.size.height.toDouble(),
          width: _bannerAd.size.width.toDouble(),
          child: AdWidget(ad: _bannerAd),
        ),
    );
  }

  Widget _orderItem(var order, int index) {
    num earningsIncentive = order['earnings_incentive'];
    num earningsTotal = order['earnings_total'];
    num earningsBase = order['earnings_base'];
    String orderReceivedAt = order['order_received_at'].toString();

    return InkWell(
      onLongPress: () {
        showCupertinoModalPopup<void>(
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
                            id: order['id'],
                            earningsIncentive:
                                double.parse(earningsIncentive.toString()),
                            earningsBase:earningsBase,
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
                          title: Text(
                            '削除しますか？',
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: [
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              child: Text(
                                '削除',
                                style: TextStyle(color: Colors.lightBlue),
                              ),
                              onPressed: () async {
                                bool response = await Provider.of<OrderList>(context, listen: false).deleteOrder(id:order['id']);
                                if(response){
                                  Navigator.pop(context);
                                  reloadWidget();
                                }else{
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) => CupertinoAlertDialog(
                                        title: Text(
                                          'エラーが発生しました',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            isDestructiveAction: true,
                                            child: Text(
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
                                      )
                                  );
                                }
                              },
                            ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              child: Text(
                                'キャンセル',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        )
                      );
                },
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                "キャンセル",
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Container(
                child: Text(
              '${index + 1}',
              textAlign: TextAlign.center,
            )),
          ),
          Expanded(
            child: Container(
                child: Text(
                    getJPDate(DateTime.parse(order['order_received_at'])),
                    textAlign: TextAlign.center)),
          ),
          Expanded(
            child: Text('×${double.parse(earningsIncentive.toString())}',
                textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text('¥${earningsTotal}', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
