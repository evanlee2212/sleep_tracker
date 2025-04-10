import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationHelper {
  static Future<void> requestPermissionsIfNeeded(BuildContext context) async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Allow Notifications'),
          content: const Text(
              'Our app would like to send you notifications to remind you to sleep and wake up.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Don't Allow"),
            ),
            TextButton(
              onPressed: () {
                AwesomeNotifications().requestPermissionToSendNotifications();
                Navigator.pop(context);
              },
              child: const Text('Allow'),
            ),
          ],
        ),
      );
    }
  }
}
