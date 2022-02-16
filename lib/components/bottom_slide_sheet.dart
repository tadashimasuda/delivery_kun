import 'package:flutter/material.dart';
import 'package:delivery_kun/constants.dart';

class BottomSlideSheet extends StatefulWidget {
  const BottomSlideSheet({Key? key}) : super(key: key);

  @override
  _BottomSlideSheetState createState() => _BottomSlideSheetState();
}

class _BottomSlideSheetState extends State<BottomSlideSheet> {
  bool isPressed = false;
  bool isFirstPressed = false;
  double selectedIncentive = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 300, //横幅
            height: 50, //高さ
            child: ElevatedButton(
              onPressed: () {
                print(selectedIncentive);
              },
              child: Text('受注する'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red, //ボタンの背景色
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}