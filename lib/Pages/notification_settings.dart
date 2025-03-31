import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_app/Pages/notification_scheduler.dart';

class NotificationSettings extends StatefulWidget {
  final SettingsRepository settingsRepository;

  const NotificationSettings({
    Key? key,
    required this.settingsRepository,
  }) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  late TimeOfDay _goodMorningTime;
  late TimeOfDay _windDownTime;

  @override
  void initState() {
    super.initState();
    _goodMorningTime = widget.settingsRepository.settings.goodMorningTimeOfDay;
    _windDownTime = widget.settingsRepository.settings.windDownTimeOfDay;
  }

  Future<void> _selectTime(BuildContext context, bool isGoodMorning) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isGoodMorning ? _goodMorningTime : _windDownTime,
    );
    if (pickedTime != null) {
      setState(() {
        if (isGoodMorning) {
          _goodMorningTime = pickedTime;
        } else {
          _windDownTime = pickedTime;
        }
      });
      //save the updated time
      await _saveSettings();
    }
  }

  Future<void> _saveSettings() async {
    //convert TimeOfDay to String
    String goodMorningTimeString =
        '${_goodMorningTime.hour.toString().padLeft(2, '0')}:${_goodMorningTime.minute.toString().padLeft(2, '0')}';
    String windDownTimeString =
        '${_windDownTime.hour.toString().padLeft(2, '0')}:${_windDownTime.minute.toString().padLeft(2, '0')}';

    //save the settings
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('goodMorningTime', goodMorningTimeString);
    await prefs.setString('windDownTime', windDownTimeString);

    //reload settings in the repository
    await widget.settingsRepository.loadSettings();

    //reschedule notifications
    await _rescheduleNotifications(); /
  }

  Future<void> _rescheduleNotifications() async {
    final scheduler = NotificationScheduler();
    final settings = widget.settingsRepository.settings;

    await scheduler.cancelAllNotifications();
    await scheduler.scheduleSleepNotification(settings.windDownTimeOfDay);
    await scheduler.scheduleWakeUpNotification(settings.goodMorningTimeOfDay);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notification Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Good Morning Notification Time'),
            subtitle: Text(
                '${_goodMorningTime.hour.toString().padLeft(2, '0')}:${_goodMorningTime.minute.toString().padLeft(2, '0')}'),
            onTap: () => _selectTime(context, true),
          ),
          ListTile(
            title: const Text('Wind Down Notification Time'),
            subtitle: Text(
                '${_windDownTime.hour.toString().padLeft(2, '0')}:${_windDownTime.minute.toString().padLeft(2, '0')}'),
            onTap: () => _selectTime(context, false),
          ),
        ],
      ),
    );
  }
}