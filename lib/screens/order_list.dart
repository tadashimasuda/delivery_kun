import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delivery_kun/services/order.dart';
import 'package:intl/intl.dart';

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
  void initState() {
    super.initState();
  }
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
              margin: EdgeInsets.only(top: 30),
              child: orderList == null
                  ? Text('a')
                  : ListView.builder(
                      itemCount: orderList.orders?.length,
                      itemBuilder: (context, int index) {
                        return Container(
                          height: 65,
                          child: _orderItem(orderList.orders?[index], index),
                        );
                      }),
            )
              :Center(child: CircularProgressIndicator())
        ));
  }

  Widget _orderItem(var order, int index) {
    num earnings_incentive = order['earnings_incentive'];
    num earnings_total = order['earnings_total'];
    String created_at = order['created_at'];

    return InkWell(
      onTap: () {
        print('Tap now');
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
                child: Text('$created_at', textAlign: TextAlign.center)),
          ),
          Expanded(
            child: Text('×$earnings_incentive', textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text('¥${earnings_total}', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
