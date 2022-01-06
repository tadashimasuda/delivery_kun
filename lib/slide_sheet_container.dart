import 'package:flutter/material.dart';

class slideSheet extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      height: 200,
      child: Column(
        children: [
          const Spacer(flex: 3,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {},
                  color: Colors.red[50],
                  shape: CircleBorder(),
                  //丸
                  child: const Text(
                    '×1.0',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MaterialButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {},
                  color: Colors.red[100],
                  shape: CircleBorder(),
                  //丸
                  child: const Text(
                    '×1.1',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MaterialButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {},
                  color: Colors.red[200],
                  shape: CircleBorder(),
                  //丸
                  child: Text(
                    '×1.2',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MaterialButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {},
                  color: Colors.red[300],
                  shape: CircleBorder(),
                  //丸
                  child: Text(
                    '×1.3',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MaterialButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {},
                  color: Colors.red[400],
                  shape: CircleBorder(),
                  //丸
                  child: Text(
                    '×1.4',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MaterialButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {},
                  color: Colors.red[500],
                  shape: CircleBorder(),
                  //丸
                  child: Text(
                    '×1.5',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(
            flex: 3
          ),
          SizedBox(
            width: 300, //横幅
            height: 50, //高さ
            child: ElevatedButton(
              onPressed: () {},
              child: Text('配達を開始する'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white30, //ボタンの背景色
              ),
            ),
          ),
          const Spacer(
            flex: 5,
          ),
        ],
      ),
    );
  }
}