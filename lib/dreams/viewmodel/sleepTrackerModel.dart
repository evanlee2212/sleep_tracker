import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class sleepTrackerModel extends ChangeNotifier {
  List<Map<String, String>> Logs = [];

  void addLog(String durationInHours, int sleepQuality) async {
    final now = DateTime.now();
    final logEntry = {
      'time': '${now.hour}:${now.minute.toString().padLeft(2, '0')} - ${now
          .month}/${now.day}',
      'duration': '$durationInHours hrs',
      'quality': '$sleepQuality/10'
    };
    
    Logs.add(logEntry);
    notifyListeners();

    //Add to firebase
  }

  int getSleepLogsLength(){
    return Logs.length;
  }

  getLogFromIndex(int index) {
    return Logs[index];
  }
}