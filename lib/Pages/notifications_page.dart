import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/settings_repository.dart';
import 'package:sleep_app/Pages/notification_settings.dart';

class NotificationsPage extends StatefulWidget {
  final SettingsRepository settingsRepository;

  const NotificationsPage({Key? key, required this.settingsRepository}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Settings'),
      ),
      body: FutureBuilder(
        future: widget.settingsRepository.loadSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //settings are loaded, build the UI
            return NotificationSettings(settingsRepository: widget.settingsRepository);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}