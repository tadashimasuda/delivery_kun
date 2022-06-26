import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import 'package:delivery_kun/screens/map_screen.dart';
import 'package:delivery_kun/components/nend_banner.dart';
import 'package:delivery_kun/screens/announcement_screen.dart';
import 'package:delivery_kun/services/announcement.dart';

class AnnouncementsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int announcement_count = context.watch<Announcement>().announcements.length;
    List announcements = context.watch<Announcement>().announcements;

    return Scaffold(
      appBar: AppBar(
        title: const Text('受信トレイ'),
        leading: Platform.isAndroid ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MapScreen()));
          },
        ):null,
      ),
      body: Container(
        child: Column(
          children:[
            const NendBanner(),
            Expanded(
                child: announcement_count > 0 ? ListView.builder(
                itemCount : announcement_count,
                itemBuilder: (context,int index){
                  return InkWell(
                    onTap: () async{
                      await context.read<Announcement>().readAnnouncement(id: announcements[index]['id']);
                      await context.read<Announcement>().getAnnouncements();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AnnouncementScreen(id:index)
                      ));
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                      ),
                      child: ListTile(
                        isThreeLine:true,
                        title: Text(
                          announcements[index]['title'],
                        ),
                        subtitle: Text(
                          announcements[index]['createdAt'],
                          style: const TextStyle(
                              fontSize: 13
                          ),
                        ),
                        trailing: announcements[index]['read'] == null ? Icon(
                          Icons.circle,
                          size: 18,
                          color: Colors.red.withOpacity(0.5),
                        ) : null,
                      ),
                    ),
                  );
                }):const Text('受信したメッセージはありません')
            )
          ],
      ),
    ));
  }
}