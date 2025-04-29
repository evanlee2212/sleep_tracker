import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatisticsModel extends ChangeNotifier {
  List<Map<String, String>> Logs = [];

  StatisticsModel() {
    init();
  }

  Future<void> init() async {
    await fetchData();
  }

  Future<void> fetchData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('sleep_logs')
      .orderBy('time', descending: true)
      .get();

    Logs.clear();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      Logs.add({
        'time': data['time'] ?? '',
        'duration': data['duration'] ?? '',
        'quality': data['quality'] ?? '',
      });
    }

    notifyListeners();
  }

  List<Map<String, String>> getQuality(int days) {
    List<Map<String, String>> filteredLogs = [];
    DateTime now = DateTime.now();

    for (var log in Logs) {
      String? timeStr = log['time'];
      String? durationStr = log['duration'];
      String? qualityStr = log['quality'];

      if (timeStr == null || timeStr.isEmpty || durationStr == null || qualityStr == null) continue;

      final parts = timeStr.split(' - ');
      if (parts.length != 2) continue;
      final timePart = parts[0];
      final datePart = parts[1];

      final timeParts = timePart.split(':');
      if (timeParts.length != 2) continue;
      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour == null || minute == null) continue;

      final dateParts = datePart.split('/');
      if (dateParts.length != 2) continue;
      final month = int.tryParse(dateParts[0]);
      final day = int.tryParse(dateParts[1]);
      if (month == null || day == null) continue;

      DateTime logTime = DateTime(now.year, month, day, hour, minute);

      double? duration = double.tryParse(durationStr.split(' ')[0]);
      if (duration == null) continue;

      DateTime endTime = logTime.add(Duration(hours: duration.toInt(), minutes: ((duration - duration.toInt()) * 60).toInt()));

      if (now.difference(logTime).inDays <= days || now.difference(endTime).inDays <= days) {
        filteredLogs.add({
          'time': timeStr,
          'duration': durationStr,
          'quality': qualityStr,
        });

      }
    }

    notifyListeners();
    return filteredLogs;
  }



  List<TimeOfDay> getHours(int days) {
    final now = DateTime.now();
    List<TimeOfDay> sleepHours = [];

    for (var log in Logs) {
      final timeStr = log['time'];
      final durationStr = log['duration'];
      if (timeStr == null || timeStr.isEmpty || durationStr == null || durationStr.isEmpty) continue;


      final parts = timeStr.split(' - ');
      if (parts.length != 2) continue;
      final timePart = parts[0];
      final datePart = parts[1];

      final timeParts = timePart.split(':');
      if (timeParts.length != 2) continue;
      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour == null || minute == null) continue;

      final dateParts = datePart.split('/');
      if (dateParts.length != 2) continue;
      final month = int.tryParse(dateParts[0]);
      final day = int.tryParse(dateParts[1]);
      if (month == null || day == null) continue;

      DateTime startTime = DateTime(now.year, month, day, hour, minute);

      double? duration = double.tryParse(durationStr.split(' ')[0]);
      if (duration == null) continue;

      DateTime endTime = startTime.add(Duration(hours: duration.toInt(), minutes: ((duration - duration.toInt()) * 60).toInt()));

      if (now.difference(startTime).inDays <= days || now.difference(endTime).inDays <= days) {
        sleepHours.add(TimeOfDay(hour: startTime.hour, minute: startTime.minute));
      }
    }

    return sleepHours;
  }


}