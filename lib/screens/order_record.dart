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
              margin: EdgeInsets.only(right: 15, left: 15),
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
                      border: TableBorder(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF000000)),
                      ),
                      children: [
                        TableRow(children: [
                          Text(
                            'オンライン',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text('受注数', style: TextStyle(color: Colors.grey))
                        ]),
                        TableRow(children: [
                          TableCell(
                            child: SizedBox(
                              height: 50,
                              child: Text(
                                '8時間24分',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: SizedBox(
                              height: 50,
                              child: Text(
                                '21',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ]),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text('明細',style: TextStyle(
                        fontSize: 30,
                      ),)
                  ),
                  Table(children: [
                    TableRow(children: [
                      Text(
                        '売上',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Text('21000',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ))
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: SizedBox(
                          height: 50,
                          child: Text(
                            '支出',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: SizedBox(
                          height: 50,
                          child: Text(
                            '1000',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: SizedBox(
                          height: 50,
                          child: Text(
                            '利益',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: SizedBox(
                          height: 50,
                          child: Text(
                            '20000',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ]),
                  ElevatedButton(
                    onPressed: (){},
                    child: Text('受注履歴を見る',),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      minimumSize: Size(double.infinity, 55),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
