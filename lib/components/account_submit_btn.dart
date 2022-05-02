import 'package:flutter/material.dart';

class SubmitBtn extends StatelessWidget {
  SubmitBtn({required this.title, required this.color, required this.onTap});

  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                )
              ]),
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: onTap);
  }
}
