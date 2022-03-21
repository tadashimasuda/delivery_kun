import 'package:delivery_kun/screens/order_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delivery_kun/services/order.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class OrderListScreen extends StatefulWidget {
  OrderListScreen({required this.userId, required this.date});

  final int userId;
  final DateTime date;

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late int userId;

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('yyyyMMdd').format(widget.date).toString();
    context.read<OrderList>().getOrders(date);
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
                          child: _orderItem(orderList.orders?[index], index),
                        );
                      }),
            )
              :Center(child: CircularProgressIndicator())
        ));
  }

  Widget _orderItem(var order, int index) {
    num earningsIncentive = order['earnings_incentive'];
    num earningsTotal = order['earnings_total'];
    String createdAt = order['created_at'].toString();

    return InkWell(
      onLongPress: (){
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
                        builder: (context) =>  OrderUpdateScreen(
                          id: order['id'],
                          earningsIncentive:earningsIncentive,
                          createdAt: createdAt
                        ),
                        fullscreenDialog: true,
                      ));
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('削除'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            cancelButton:CupertinoActionSheetAction(
              child: Text("キャンセル",style: TextStyle(color: Colors.redAccent),),
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
                    DateFormat('hh時mm分').format(DateTime.parse(createdAt)).toString(),
                    textAlign: TextAlign.center
                )
            ),
          ),
          Expanded(
            child: Text('×$earningsIncentive', textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text('¥${earningsTotal}', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
