import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sleep_app/dreams/viewmodel/sleepTrackerModel.dart';

class sleepTrackerPresenter {
  late sleepTrackerModel model = new sleepTrackerModel();

  void addSleepLog(String durationInHours, int sleepQuality){
    model.addLog(durationInHours, sleepQuality);
  }

  int getSleepLogsLength() {
    return model.getSleepLogsLength();
  }

  getLog(int index) {
    return model.getLogFromIndex(index);
  }
}