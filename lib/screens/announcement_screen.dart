import 'package:delivery_kun/components/nend_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:delivery_kun/services/announcement.dart';

class AnnouncementScreen extends StatelessWidget {
  AnnouncementScreen({required int this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    List announcements = context.read<Announcement>().announcements;
    return Scaffold(
      appBar: AppBar(
        title: const Text('受信メッセージ'),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                announcements[id]['title'],
                style: const TextStyle(
                  fontSize: 30
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                child: Text(
                  announcements[id]['description'],
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NendBanner()
    );
  }
}
