import 'package:flutter/material.dart';
import 'notification_scheduler.dart';
import 'notification_settings.dart';
import 'settings_repository.dart';

abstract class NotificationsView {
  void onSettingsLoaded(NotificationSettings settings);
  void onSettingsSaved();
}

class NotificationsPresenter {
  final NotificationsView _view;
  final NotificationScheduler _scheduler;
  final SettingsRepository _repository;

  NotificationsPresenter(this._view, this._scheduler, this._repository);

  void loadSettings() async {
    final settings = await _repository.loadSettings();
    _view.onSettingsLoaded(settings);
  }

  void saveSettings(NotificationSettings settings) async {
    await _repository.saveSettings(settings);
    await _scheduler.cancelAllNotifications();
    await _scheduler.scheduleSleepNotification(settings.windDownTime);
    await _scheduler.scheduleWakeUpNotification(settings.goodMorningTime);
    _view.onSettingsSaved();
  }
}