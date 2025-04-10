import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';
import '../services/notification_scheduler.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late TimeOfDay _goodMorningTime;
  late TimeOfDay _windDownTime;
  final SettingsRepository _repository = SettingsRepository();
  final NotificationScheduler _scheduler = NotificationScheduler();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _repository.loadSettings();
    final settings = _repository.settings;
    _goodMorningTime = settings.goodMorningTimeOfDay;
    _windDownTime = settings.windDownTimeOfDay;
    setState(() {
      _isLoading = false;
    });
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
      await _saveSettings();
    }
  }

  Future<void> _saveSettings() async {
    await _repository.saveNotificationTimes(_goodMorningTime, _windDownTime);
    await _repository.loadSettings();
    final settings = _repository.settings;

    await _scheduler.cancelAllNotifications();
    await _scheduler.scheduleSleepNotification(settings.windDownTimeOfDay);
    await _scheduler.scheduleWakeUpNotification(settings.goodMorningTimeOfDay);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification settings saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Settings'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
              subtitle: Text('${_goodMorningTime.format(context)}'),
              onTap: () => _selectTime(context, true),
            ),
            ListTile(
              title: const Text('Wind Down Notification Time'),
              subtitle: Text('${_windDownTime.format(context)}'),
              onTap: () => _selectTime(context, false),
            ),
          ],
        ),
      ),
    );
  }
}

