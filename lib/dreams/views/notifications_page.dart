import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';
import '../services/notification_scheduler.dart';
import '../repositories/notification_repository.dart';
import 'dart:async';
import '../../components/theme.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late TimeOfDay _goodMorningTime;
  late TimeOfDay _windDownTime;
  final SettingsRepository _prefsRepo = SettingsRepository();
  final NotificationScheduler _scheduler = NotificationScheduler();
  final NotificationsRepository _firestoreRepo = NotificationsRepository();
  bool _isLoading = true;
  late final StreamSubscription<Map<String, TimeOfDay>> _settingsSub;

  @override
  void initState() {
    super.initState();
    _initialize();
    _settingsSub = _firestoreRepo.watchSettings().listen((prefs) {
      if (prefs.containsKey('goodMorning') && prefs.containsKey('windDown')) {
        setState(() {
          _goodMorningTime = prefs['goodMorning']!;
          _windDownTime = prefs['windDown']!;
        });
        _rescheduleAll();
      }
    });
  }

  @override
  void dispose() {
    _settingsSub.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    await _prefsRepo.loadSettings();
    final settings = _prefsRepo.settings;
    _goodMorningTime = settings.goodMorningTimeOfDay;
    _windDownTime = settings.windDownTimeOfDay;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _selectTime(BuildContext context, bool isGoodMorning) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isGoodMorning ? _goodMorningTime : _windDownTime,
    );
    if (picked != null) {
      setState(() {
        if (isGoodMorning) _goodMorningTime = picked;
        else _windDownTime = picked;
      });
      await _saveSettings();
    }
  }

  Future<void> _saveSettings() async {
    await _prefsRepo.saveNotificationTimes(_goodMorningTime, _windDownTime);
    await _firestoreRepo.saveSettings(_goodMorningTime, _windDownTime);
    await _rescheduleAll();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification settings saved')),
      );
    }
  }

  Future<void> _rescheduleAll() async {
    await _scheduler.cancelAllNotifications();
    await _scheduler.scheduleSleepNotification(_windDownTime);
    await _scheduler.scheduleWakeUpNotification(_goodMorningTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.buildAppBar('Notifications Settings'),
      body: BackgroundWrapper(
  child: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : Center( 
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 600, 
              ),
              child: Card(
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notification Settings',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        title: const Text('Good Morning Notification Time'),
                        subtitle: Text(_goodMorningTime.format(context)),
                        onTap: () => _selectTime(context, true),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        title: const Text('Wind Down Notification Time'),
                        subtitle: Text(_windDownTime.format(context)),
                        onTap: () => _selectTime(context, false),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
