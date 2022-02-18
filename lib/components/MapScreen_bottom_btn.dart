import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'dart:async';
import 'package:delivery_kun/screens/MapScreen.dart';

class MapScreenBottomBtn extends StatefulWidget {
  const MapScreenBottomBtn({Key? key}) : super(key: key);

  @override
  _MapScreenBottomBtnState createState() => _MapScreenBottomBtnState();
}

class _MapScreenBottomBtnState extends State<MapScreenBottomBtn> {

  Widget getTimeText() {
    var now = DateTime.now();
    return Text('記録時間：${now.hour}時${now.minute}分');
  }

  Future<dynamic> IOSDialog() {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('記録しますか？'),
            content: getTimeText(),
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
  }

  dynamic AndroidDialog() {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('記録しますか？'),
          content: getTimeText(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                print(DateTime.now());
              },
              child: Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                print(DateTime.now());
              },
              child: Text('記録する'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
              ElevatedButton(
                onPressed: () {},
                child: Icon(Icons.list_alt,color: Colors.grey,),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  primary: Colors.white,
                  minimumSize: Size(65, 65),
                  elevation: 15,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Platform.isIOS ? IOSDialog() : AndroidDialog();
                },
                child: Text('受注'),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  primary: Colors.red,
                  minimumSize: Size(90, 90),
                  elevation: 15,
                ),
              ),
              ElevatedButton(
                onPressed:currentLocation,
                child: Icon(Icons.location_on,color: Colors.grey,),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  primary: Colors.white,
                  minimumSize: Size(65, 65),
                  elevation: 15,
                ),
              ),
          ],
      ),
    );
  }
}
