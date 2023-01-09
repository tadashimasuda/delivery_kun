import 'package:flutter/material.dart';

import 'package:delivery_kun/screens/sign_in_screen.dart';
import 'package:delivery_kun/screens/sign_up_screen.dart';
import 'package:delivery_kun/components/drawer_list_text.dart';

class LogOutDrawer extends StatelessWidget {
  const LogOutDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 30,
        ),
        ListTile(
          title: const drawerListText(
            title: 'ログイン',
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInForm(),
                ));
          },
        ),
        const SizedBox(
          height: 8,
        ),
        ListTile(
          title: const drawerListText(
            title: '新規作成',
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpForm(),
                ));
          },
        ),
      ],
    );
  }
}
