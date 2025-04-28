import 'package:flutter/material.dart';

abstract class SleepCycleView {
  void updateView(TimeOfDay? sleepTime, List<String> suggestions);
}