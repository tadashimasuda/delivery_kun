import 'package:delivery_kun/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:delivery_kun/services/user_status.dart';
import 'package:delivery_kun/screens/user_status_screen.dart';

class DaysEarningsTotalBottomSheet extends StatelessWidget {
  const DaysEarningsTotalBottomSheet({
    Key? key,
    required this.deviceHeight,
  }) : super(key: key);

  final double deviceHeight;

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
            child:BottomSheetText(title: '¥${context.watch<Status>().userDaysEarningsTotal}')
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