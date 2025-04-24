import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationScheduler {
  //wind down reminder
  Future<void> scheduleSleepNotification(TimeOfDay time) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'scheduled_channel',
        title: 'Wind Down Time!',
        body: 'It\'s time to start winding down for bed. Limit screen time and avoid heavy food, caffeine and alcohol for high quality sleep!',
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
  }

  //wake up text or possible goal additions
  Future<void> scheduleWakeUpNotification(
      TimeOfDay time, {
        String? customBody,
      }) async {
    //cancel the previous wake notification (ID = 2)
    await AwesomeNotifications().cancel(2);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'scheduled_channel',
        title: 'Good Morning!',
        body: customBody ?? 'It\'s time to wake up!',
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
  }

  Future<void> cancelAllNotifications() =>
      AwesomeNotifications().cancelAll();
}
