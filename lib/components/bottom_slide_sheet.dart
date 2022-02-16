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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      alignment: Alignment.topCenter,
      child:Column(
        children: [
          SizedBox(height: 30,),
          ElevatedButton(
            onPressed: () {
              print('ok');
            },
            child: Text('受注する'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              padding: EdgeInsets.only(left:100,right: 100,top: 20,bottom: 20),
            ),
          ),
        ],
      ),
    );
  }
}