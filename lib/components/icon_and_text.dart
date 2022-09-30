import 'package:flutter/material.dart';

class IconAndText extends StatelessWidget {
  const IconAndText({required IconData this.icon, required String this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                icon,
                size: 20,
                color: Colors.green,
              ),
            ),
            TextSpan(
              text: text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
