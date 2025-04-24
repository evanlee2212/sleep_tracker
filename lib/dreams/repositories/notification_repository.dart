import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth      = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  //save the user's notification prefs in Firestoe
  Future<void> saveSettings(TimeOfDay goodMorning, TimeOfDay windDown) {
    final data = {
      'goodMorning': {'h': goodMorning.hour, 'm': goodMorning.minute},
      'windDown':   {'h': windDown.hour,   'm': windDown.minute},
    };
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('notification_settings')
        .doc('prefs')
        .set(data);
  }

  Stream<Map<String, TimeOfDay>> watchSettings() {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) return Stream.value({});
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notification_settings')
          .doc('prefs')
          .snapshots()
          .map((snap) {
        final d = snap.data();
        if (d == null) return {};
        final gm = d['goodMorning'] as Map<String,dynamic>;
        final wd = d['windDown']   as Map<String,dynamic>;
        return {
          'goodMorning': TimeOfDay(hour: gm['h'], minute: gm['m']),
          'windDown':   TimeOfDay(hour: wd['h'], minute: wd['m']),
        };
      });
    });
  }
}
