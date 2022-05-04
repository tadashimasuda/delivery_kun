import 'package:flutter/material.dart';

import 'package:delivery_kun/screens/user_status_screen.dart';

class DaysEarningsTotalBottomSheet extends StatelessWidget {
  const DaysEarningsTotalBottomSheet({
    Key? key,
    required this.deviceHeight,
    required this.todayTotal
  }) : super(key: key);

  final double deviceHeight;
  final int todayTotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Center(
            child: todayTotal != null ?
            BottomSheetText(title: '¥${todayTotal}') :
            BottomSheetText(title: 'データが取得できませんでした')
          ),
          Positioned(
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return FractionallySizedBox(
                        heightFactor: 0.90,
                        child: UserStatusScreen()
                    );
                  }
                );
              },
              icon: Icon(Icons.list)
            ),
            height: deviceHeight * 0.10,
            right: 0
          ),
        ],
      ),
    );
  }
}

class BottomSheetText extends StatelessWidget {
  BottomSheetText({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500
      ),
    );
  }
}