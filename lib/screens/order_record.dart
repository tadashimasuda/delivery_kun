import 'package:flutter/material.dart';

class OrderRecord extends StatefulWidget {
  const OrderRecord({Key? key}) : super(key: key);

  @override
  _OrderRecordState createState() => _OrderRecordState();
}

class _OrderRecordState extends State<OrderRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('売り上げ履歴'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  '2月20日(土)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
            Container(
              height: 250,
              color: Colors.grey,
            ),
            Container(
              margin: EdgeInsets.only(right:15,left:15),
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'ステータス',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      )),
                  Table(
                      children: [
                        TableRow(
                            children: [
                          Text('オンライン'),
                          Text('受注数')
                        ]),
                        TableRow(children: [
                          Text('8時間24分'),
                          Text('21')
                    ]),
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
