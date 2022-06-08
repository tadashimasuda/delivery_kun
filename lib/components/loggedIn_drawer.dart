import 'package:delivery_kun/screens/setting_incentives_sheet.dart';
import 'package:delivery_kun/screens/setting_incentives_sheets.dart';
import 'package:delivery_kun/services/incentive_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:delivery_kun/services/auth.dart';
import 'package:delivery_kun/screens/user_status_screen.dart';
import 'package:delivery_kun/screens/setting_screen.dart';
import 'package:delivery_kun/screens/setting_incentive_screen.dart';
import 'package:delivery_kun/components/drawer_list_text.dart';
import 'package:delivery_kun/services/todayIncentive.dart';

class LoggedInDrawer extends StatefulWidget {
  const LoggedInDrawer({Key? key}) : super(key: key);

  @override
  _LoggedInDrawerState createState() => _LoggedInDrawerState();
}

class _LoggedInDrawerState extends State<LoggedInDrawer> {
  String _url = 'https://docs.google.com/forms/d/1-EyD9wgMg3dsEL1B26RwCGv5NmYUZnDCsUTv4n-TvZs/edit?usp=sharing';
  String _noteUrl = 'https://note.com/deliverykun/n/n143325d75507';

  void _launchURL() async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  void _launchNoteURL() async {
    if (!await launch(_noteUrl)) throw 'Could not launch $_noteUrl';
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
                auth.user!.name,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              accountEmail: Text(''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("images/user.png")
              ),
            ),
          ]),
          ListTile(
            title: drawerListText(title: '配達ステータス'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserStatusScreen(),
                ));
            },
          ),
          SizedBox(height: 8,),
          ListTile(
            title: drawerListText(title: 'インセンティブ設定'),
            onTap: () async {
              await context.read<Incentive>().getTodayIncentive();

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingIncentiveScreen())
              );
            },
          ),
          SizedBox(height: 8,),
          ListTile(
            title: drawerListText(title: 'インセンティブシート設定'),
            onTap: () async {
              await context.read<IncentiveSheet>().getIncentives();

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingIncentivesSheets())
              );
            },
          ),
          SizedBox(height: 8,),
          ListTile(
            title: drawerListText(title: 'ユーザー設定'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingScreen())
              );
            },
          ),
          SizedBox(height: 8,),
          ListTile(
              title: drawerListText(title: 'アプリの使い方'),
              onTap: _launchNoteURL
          ),
          SizedBox(height: 8,),
          ListTile(
            title: drawerListText(title: 'ログアウト'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          SizedBox(height: 8,),
          ListTile(
            title: drawerListText(title: 'お問い合わせ'),
            onTap: _launchURL
          ),
        ],
      );
    });
  }
}