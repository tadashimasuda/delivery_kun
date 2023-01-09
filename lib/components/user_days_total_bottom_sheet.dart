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
    int total = context.watch<Status>().userDaysEarningsTotal;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Center(child: BottomSheetText(title: '¥$total')),
          Positioned(
              child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return const FractionallySizedBox(
                              heightFactor: 0.90, child: UserStatusScreen());
                        });
                  },
                  icon: const Icon(Icons.list)),
              height: deviceHeight * 0.10,
              right: 0),
        ],
      ),
    );
  }
}

class BottomSheetText extends StatelessWidget {
  const BottomSheetText({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
    );
  }
}
