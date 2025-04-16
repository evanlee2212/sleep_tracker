import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsRepository {
  late Settings _settings;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final windDownTime = prefs.getString('windDownTime') ?? '22:00';
    final goodMorningTime = prefs.getString('goodMorningTime') ?? '07:00';
    _settings = Settings(windDownTime: windDownTime, goodMorningTime: goodMorningTime);
  }

  Future<void> saveNotificationTimes(TimeOfDay goodMorningTime, TimeOfDay windDownTime) async {
    final prefs = await SharedPreferences.getInstance();

    final goodMorningTimeString =
        '${goodMorningTime.hour.toString().padLeft(2, '0')}:${goodMorningTime.minute.toString().padLeft(2, '0')}';
    final windDownTimeString =
        '${windDownTime.hour.toString().padLeft(2, '0')}:${windDownTime.minute.toString().padLeft(2, '0')}';

    await prefs.setString('goodMorningTime', goodMorningTimeString);
    await prefs.setString('windDownTime', windDownTimeString);
  }

  Settings get settings => _settings;
}

class Settings {
  final String windDownTime;
  final String goodMorningTime;

  Settings({required this.windDownTime, required this.goodMorningTime});

  TimeOfDay get windDownTimeOfDay => _parseTimeOfDay(windDownTime);
  TimeOfDay get goodMorningTimeOfDay => _parseTimeOfDay(goodMorningTime);

  TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
