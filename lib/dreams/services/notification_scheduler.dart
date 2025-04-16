import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationScheduler {
  Future<void> scheduleSleepNotification(TimeOfDay time) async {
    print('NotificationScheduler: scheduleSleepNotification() called');
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'scheduled_channel',
        title: 'Wind Down Time!',
        body: 'It\'s time to start winding down for bed.',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: time.hour,
        minute: time.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
    print('NotificationScheduler: scheduleSleepNotification() completed');
  }

  Future<void> scheduleWakeUpNotification(TimeOfDay time) async {
    print('NotificationScheduler: scheduleWakeUpNotification() called');
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'scheduled_channel',
        title: 'Good Morning!',
        body: 'It\'s time to wake up!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: time.hour,
        minute: time.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
    print('NotificationScheduler: scheduleWakeUpNotification() completed');
  }

  Future<void> cancelAllNotifications() async {
    print('NotificationScheduler: cancelAllNotifications() called');
    await AwesomeNotifications().cancelAll();
    print('NotificationScheduler: cancelAllNotifications() completed');
  }
}