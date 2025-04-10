// app_initializer.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

class AppInitializer {
  Future<void> initialize() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled Notifications',
          channelDescription: 'For sleep/wake reminders',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          locked: true,
          defaultRingtoneType: DefaultRingtoneType.Notification,
        ),
      ],
    );
  }
}
