import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SleepCycleModel {
  TimeOfDay? sleepTime;
  List<String> suggestions = [];

  SleepCycleModel({this.sleepTime});

  void generateSuggestions() {
    if (sleepTime == null) return;

    final now = DateTime.now();
    final baseTime = DateTime(now.year, now.month, now.day, sleepTime!.hour, sleepTime!.minute)
        .add(const Duration(minutes: 15));

    suggestions = List.generate(4, (i) {
      final suggestionTime = baseTime.add(Duration(minutes: 90 * ((i+1) + 3)));
      return DateFormat.jm().format(suggestionTime);
    });

  }
}