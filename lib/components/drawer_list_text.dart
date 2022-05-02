import 'package:flutter/material.dart';

class drawerListText extends StatelessWidget {
  const drawerListText({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}