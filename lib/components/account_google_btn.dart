import 'package:flutter/material.dart';

class GoogleAuthButton extends StatelessWidget {
  GoogleAuthButton({required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey)
        ),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          children: [
            //TODO:google Icon
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
      ),
      onTap: () {
        //TODO:Provider google login function
      },
    );
  }
}