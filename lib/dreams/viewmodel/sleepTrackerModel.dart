import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class sleepTrackerModel extends ChangeNotifier {
  List<Map<String, String>> Logs = [];

  List<Map<String, String>> get logs => Logs;

  SleepTrackerModel() {
    fetchEntries();
  }

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

    final user = FirebaseAuth.instance.currentUser;

    if (user != null){
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('sleep_logs')
          .add(logEntry);
    } else {
      print("No user is signed in");
    }
  }

  int getSleepLogsLength(){
    return Logs.length;
  }

  getLogFromIndex(int index) {
    return Logs[index];
  }

  Future<void> fetchEntries() async {
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
}