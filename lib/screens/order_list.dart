import 'package:flutter/material.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {

  List _order = [
    {
      'time':'12時20分',
      'incentive':'1.5',
    },
    {
      'time':'13時20分',
      'incentive':'1.2',
    },
    {
      'time':'14時20分',
      'incentive':'1.2',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2月20日(土)'),
      ),
      body: Container(
        margin:EdgeInsets.only(top: 30),
        child: ListView.builder(
          itemCount: _order.length,
          itemBuilder: (BuildContext context,int index){
            return Container(
              height:65,
              child: _orderItem(index),
            );
          }
        ),
      ),
    );
  }

  Widget _orderItem(int index){
    String get_order_time =_order[index]['time'];
    String order_incentive = _order[index]['incentive'];
    double get_pay = double.parse(order_incentive) * 715;

    return InkWell(
      onTap: (){
        print('Tap now');
      },
      child: Row(
        children: [
          Expanded(
            child:Container(
                child: Text('${index + 1}',textAlign: TextAlign.center,)
            ),
          ),
          Expanded(
            child:Container(
                child: Text('$get_order_time',textAlign: TextAlign.center)
            ),
          ),
          Expanded(
            child:Text('×$order_incentive',textAlign: TextAlign.center),
          ),
          Expanded(
            child:Text('¥${get_pay.floor()}',textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
