import 'package:delivery_kun/screens/setting_screen.dart';
import 'package:delivery_kun/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginDrawer extends StatefulWidget {
  const LoginDrawer({Key? key}) : super(key: key);

  @override
  _LoginDrawerState createState() => _LoginDrawerState();
}

class _LoginDrawerState extends State<LoginDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (context, auth, child) {
      return ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.only(top: 50.0),
        children: [
          Column(children: [
            UserAccountsDrawerHeader(
              accountName: Text(auth.user.name),
              accountEmail: Text(''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80"),
              ),
            ),
          ]),
          ListTile(
            title: const Text('ログアウト'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          ListTile(
            title: const Text('設定'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingScreen())
              );
            },
          )
        ],
      );
    });
  }
}
