import 'package:flutter/material.dart';

import 'package:delivery_kun/screens/sign_in_screen.dart';
import 'package:delivery_kun/screens/sign_up_screen.dart';
import 'package:delivery_kun/components/drawer_list_text.dart';

class NotLoggedInDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 30,),
        ListTile(
          title: drawerListText(title: 'ログイン',),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInForm(),
                ));
          },
        ),
        SizedBox(height: 8,),
        ListTile(
          title: drawerListText(title: '新規作成',),
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