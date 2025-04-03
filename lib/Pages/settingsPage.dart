import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/notification.dart';

import '../components/menu_button.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings'
        ),
        backgroundColor: Colors.deepPurpleAccent,
        toolbarHeight: 100,
      ),
      body: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              MenuButton(
              text: 'New Sleep Entry',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage())),
            ),
            ]
            ),
          )
      ),
    );
  }
}