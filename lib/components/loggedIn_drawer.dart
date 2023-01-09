import 'package:delivery_kun/screens/announcements_list_screen.dart';
import 'package:delivery_kun/screens/setting_incentives_sheets_screen.dart';
import 'package:delivery_kun/screens/subscription_screen.dart';
import 'package:delivery_kun/services/announcement.dart';
import 'package:delivery_kun/services/incentive_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:delivery_kun/services/auth.dart';
import 'package:delivery_kun/screens/user_status_screen.dart';
import 'package:delivery_kun/screens/setting_user_screen.dart';
import 'package:delivery_kun/components/drawer_list_text.dart';

class LoggedInDrawer extends StatefulWidget {
  const LoggedInDrawer({Key? key}) : super(key: key);

  @override
  _LoggedInDrawerState createState() => _LoggedInDrawerState();
}

class _LoggedInDrawerState extends State<LoggedInDrawer> {
  final String _url = 'https://twitter.com/deliveryKun';
  final String _noteUrl = 'https://note.com/deliverykun/n/n143325d75507';

  void _launchURL() async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  void _launchNoteURL() async {
    if (!await launch(_noteUrl)) throw 'Could not launch $_noteUrl';
  }

  @override
  Widget build(BuildContext context) {
    int readCnt = context.watch<Announcement>().is_not_read_num;

    return Consumer<Auth>(builder: (context, auth, child) {
      return ListView(
        // Important: Remove any padding from the ListView.
        padding: const EdgeInsets.only(top: 50.0),
        children: [
          Column(children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                auth.user!.name,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              accountEmail: const Text(''),
              currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("images/user.png")),
            ),
          ]),
          ListTile(
            title: const drawerListText(title: '広告非表示'),
            trailing: readCnt > 0
                ? CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 13,
                    child: Text(
                      readCnt.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : null,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PurchaseSubscriptionScreen(),
                  ));
            },
          ),
          ListTile(
            title: const drawerListText(title: '受信トレイ'),
            trailing: readCnt > 0
                ? CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 13,
                    child: Text(
                      readCnt.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : null,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnnouncementsListScreen(),
                  ));
            },
          ),
          ListTile(
            title: const drawerListText(title: '配達ステータス'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserStatusScreen(),
                  ));
            },
          ),
          const SizedBox(
            height: 8,
          ),
          ListTile(
            title: const drawerListText(title: 'インセンティブシート設定'),
            onTap: () async {
              await context.read<IncentiveSheet>().getIncentives();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingIncentivesSheets()));
            },
          ),
          const SizedBox(
            height: 8,
          ),
          ListTile(
            title: const drawerListText(title: 'ユーザー設定'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingUserScreen()));
            },
          ),
          const SizedBox(
            height: 8,
          ),
          ListTile(
              title: const drawerListText(title: 'アプリの使い方'),
              onTap: _launchNoteURL),
          const SizedBox(
            height: 8,
          ),
          ListTile(
            title: const drawerListText(title: 'ログアウト'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          const SizedBox(
            height: 8,
          ),
          ListTile(
              title: const drawerListText(title: 'お問い合わせ'), onTap: _launchURL),
        ],
      );
    });
  }
}
