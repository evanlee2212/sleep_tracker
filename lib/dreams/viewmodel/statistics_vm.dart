import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_app/dreams/presenter/statistics_presenter.dart';

class FakeFirebase {
  static const List<String> LogTags = [
    "good", "well rested", "restless", "amazing", "bad", "tired", "energized", "groggy", "good",
    "alert", "well rested", "moody", "bad", "refreshed", "restless", "okay", "exhausted", "amazing", "drained",
    "good", "well rested", "restless", "sluggish", "bad", "tired", "great", "lethargic", "good", "awake",
    "well rested", "refreshed", "groggy", "restless", "good", "bad", "calm", "alert", "peaceful", "moody",
    "okay", "tired", "good", "restless", "amazing", "well rested", "burnt out", "decent", "bad", "refreshed", "fatigued", 
    "energized", "on edge", "restless", "good", "mentally sharp", "foggy", "heavy", "light", "groggy", "happy", "neutral",
    "good", "bad", "meh", "uplifted", "restless", "so-so", "great", "tense", "free", "tired", "well rested", "good",
    "bad", "sleepy", "ready", "moody", "recharged", "drained", "good", "unstable", "fine", "refreshed", "heavy-eyed",
    "restless", "good", "fine", "bad", "chill", "groggy", "bright", "alert", "lazy", "motivated", "good"];
  
  List<TimeOfDay> bedTime = [];
  List<TimeOfDay> wakeTime = [];
  
  
  FakeFirebase() {
    final random = Random();
    for (int i = 0; i < 100; i++) {
      // Generate random bed time (between 8 PM and 2 AM)
      final bed = TimeOfDay(
        hour: random.nextInt(6) + 20 % 24, // 20–1 (8 PM to 1 AM)
        minute: random.nextInt(60),
      );

      bedTime.add(bed);

      // Add 4 to 10 hours to bed time
      int additionalMinutes = (random.nextInt(7) + 4) * 60; // 4–10 hours
      int totalMinutes = bed.hour * 60 + bed.minute + additionalMinutes;

      final wake = TimeOfDay(
        hour: (totalMinutes ~/ 60) % 24,
        minute: totalMinutes % 60,
      );

      wakeTime.add(wake);
    }
  }
  
}

class statisticsModel extends ChangeNotifier {
  FakeFirebase data = FakeFirebase();
  Map<String, int> Tags = {};

  statisticsModel() {
    condenseTags();
    calculateSleepTime();
  }

  void condenseTags() {
    for (String verb in FakeFirebase.LogTags) {
      if (Tags.containsKey(verb)) {
        Tags[verb] = Tags[verb]! + 1;
      } else {
        Tags[verb] = 1;
      }
    }
  }
}