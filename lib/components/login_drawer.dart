import 'package:delivery_kun/screens/user_status.dart';
import 'package:url_launcher/url_launcher.dart';
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
  String _url =
      'https://docs.google.com/forms/d/1-EyD9wgMg3dsEL1B26RwCGv5NmYUZnDCsUTv4n-TvZs/edit?usp=sharing';

  void _launchURL() async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (context, auth, child) {
      return ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.only(top: 50.0),
        children: [
          Column(children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                auth.user.name,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              accountEmail: Text(''),
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("images/user.png")),
            ),
          ]),
          ListTile(
            title: const Text('配達ステータス'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserStatusScreen(),
                  ));
            },
          ),
          ListTile(
            title: const Text('設定'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingScreen()));
            },
          ),
          ListTile(
            title: const Text('ログアウト'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          ListTile(title: const Text('お問い合わせ'), onTap: _launchURL),
        ],
      );
    });
  }
}
