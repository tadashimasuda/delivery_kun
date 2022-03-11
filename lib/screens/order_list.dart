import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delivery_kun/services/order.dart';

class OrderListScreen extends StatefulWidget {
  OrderListScreen({required this.userId, required this.date});

  final int userId;
  final String date;

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
    Provider.of<OrderList>(context, listen: false)
        .getOrders(widget.userId, '20220310');
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.date),
        ),
        body: Consumer<OrderList>(
          builder: (context, orderList, _) {
            return Container(
              margin: EdgeInsets.only(top: 30),
              child: orderList == null
                  ? Text('a')
                  : ListView.builder(
                      itemCount: orderList.orders.length,
                      itemBuilder: (context, int index) {
                        return Container(
                          height: 65,
                          child: _orderItem(orderList.orders[index], index),
                        );
                      }),
            );
          },
        ));
  }

  Widget _orderItem(var order, int index) {
    int earnings_total = order['earnings_total'];
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
            child: Text('×$earnings_total', textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text('¥${earnings_total}', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
