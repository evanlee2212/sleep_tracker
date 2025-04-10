import 'package:flutter/material.dart';
import 'notification_scheduler.dart';
import 'settings_repository.dart';

class StartupService {
  final SettingsRepository _repository = SettingsRepository();
  final NotificationScheduler _scheduler = NotificationScheduler();

  Future<void> initialize() async {
    await _repository.loadSettings();
    final settings = _repository.settings;
    await _scheduler.cancelAllNotifications();
    await _scheduler.scheduleSleepNotification(settings.windDownTimeOfDay);
    await _scheduler.scheduleWakeUpNotification(settings.goodMorningTimeOfDay);
  }
}
