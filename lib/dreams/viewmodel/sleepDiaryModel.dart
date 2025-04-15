//Varsha

import 'package:flutter/material.dart';

class SleepDiaryModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _entries = [];

  List<Map<String, dynamic>> get entries => _entries;

  void addEntry({
    required DateTime date,
    required TimeOfDay bedtime,
    required TimeOfDay wakeTime,
    required String reflection,
    required List<String> tags,
  }) {
    _entries.add({
      'date': date,
      'bedtime': bedtime,
      'wakeTime': wakeTime,
      'reflection': reflection,
      'tags': tags,
    });
    notifyListeners();
  }

  List<Map<String, dynamic>> filterByTag(String tag) {
    return _entries.where((entry) => entry['tags'].contains(tag)).toList();
  }

  double getAverageSleepDuration() {
    double totalHours = 0;

    for (var entry in _entries) {
      final bedtime = entry['bedtime'] as TimeOfDay;
      final wakeTime = entry['wakeTime'] as TimeOfDay;

      final bedDate = DateTime(0, 0, 0, bedtime.hour, bedtime.minute);
      final wakeDate = DateTime(0, 0, 1, wakeTime.hour, wakeTime.minute);

      final duration = wakeDate.difference(bedDate).inMinutes / 60.0;
      totalHours += duration;
    }

    return _entries.isNotEmpty ? totalHours / _entries.length : 0.0;
  }
}
