import 'dart:async';

import 'package:sleep_app/dreams/viewmodel/sleepTrackerModel.dart';

class sleepTrackerPresenter {
  late sleepTrackerModel model = sleepTrackerModel();

  void addSleepLog(String durationInHours, int sleepQuality){
    model.addLog(durationInHours, sleepQuality);
  }

  int getSleepLogsLength() {
    return model.getSleepLogsLength();
  }

  getLog(int index) {
    return model.getLogFromIndex(index);
  }

  Future<void> fetchEntries() {
    return model.fetchEntries();
  }

  void removeSleepLog(int index) {
    model.Logs.removeAt(index);
  }
}