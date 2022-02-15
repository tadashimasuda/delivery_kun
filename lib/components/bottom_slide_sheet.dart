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

  dynamic incentiveColor(double num){
    if(isFirstPressed){
      return Colors.grey;
    }else{
      return kincentive[num.toStringAsFixed(1)];
    }
  }

  ButtonBar incentiveBtn(){
    List<ElevatedButton> incentiveBtns = [];

    for(double index = 1.0;index <= 3.1;index+=0.1){
        var newItem = ElevatedButton(
          onPressed: (){
            setState(() {
              selectedIncentive = double.parse(index.toStringAsFixed(1));
              this.isPressed = !this.isPressed;
              this.isFirstPressed = true;
            });
          },
          child: Text('×${index.toStringAsFixed(1)}'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
            primary:selectedIncentive == double.parse(index.toStringAsFixed(1)) ? kincentive[index.toStringAsFixed(1)] : incentiveColor(index),
            onPrimary: Colors.black,
            shape: const CircleBorder(),
          ),
        );
        incentiveBtns.add(newItem);
      }

    return ButtonBar(
      children: incentiveBtns,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: incentiveBtn(),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 300, //横幅
            height: 50, //高さ
            child: ElevatedButton(
              onPressed: () {
                print(selectedIncentive);
              },
              child: Text('配達を開始する'),
              style: ElevatedButton.styleFrom(
                primary: selectedIncentive == 0.0 ? Colors.grey : Colors.green, //ボタンの背景色
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}