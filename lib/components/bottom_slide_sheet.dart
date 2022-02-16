import 'package:flutter/material.dart';
import 'package:delivery_kun/constants.dart';
import 'package:flutter/cupertino.dart';

class BottomSlideSheet extends StatefulWidget {
  const BottomSlideSheet({Key? key}) : super(key: key);

  @override
  _BottomSlideSheetState createState() => _BottomSlideSheetState();
}

class _BottomSlideSheetState extends State<BottomSlideSheet> {

  Widget getTimeWidget(){
    var now = DateTime.now();
    return Text('記録時間：${now.hour}時${now.minute}分');
  }

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
              showCupertinoDialog(context: context, builder: (context){
                return CupertinoAlertDialog(
                  title: Text('記録しますか？'),
                  content: getTimeWidget(),
                  actions: [
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: Text('キャンセル'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text('記録する'),
                      onPressed: () {
                        Navigator.pop(context);
                        print(DateTime.now());
                      },
                    ),
                  ],
                );
              });
            },
            child: Text('受注記録'),
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