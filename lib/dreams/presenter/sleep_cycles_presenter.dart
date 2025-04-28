import 'package:flutter/material.dart';

import '../contracts/sleep_cycles_contract.dart';
import '../models/sleep_cycles_model.dart';

class SleepCyclePresenter {
  late SleepCycleModel _model;
  late SleepCycleView _view;

  SleepCyclePresenter(SleepCycleView view) {
    _view = view;
    _model = SleepCycleModel();
  }

  void pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      _model.sleepTime = picked;
      _model.generateSuggestions();
      _view.updateView(_model.sleepTime, _model.suggestions);
    }
  }
}