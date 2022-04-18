import 'package:delivery_kun/screens/sign_in_screen.dart';
import 'package:delivery_kun/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

class NotLoginDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 30,),
        ListTile(
          title: Text(
            'ログイン',
            style: TextStyle(
                fontWeight: FontWeight.w600
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInForm(),
                ));
          },
        ),
        ListTile(
          title: const Text(
            'アカウント登録',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpForm(),
                ));
          },
        ),
      ],
    );
  }
}