import 'package:flutter/material.dart';
import 'package:sleep_app/dreams/views/statistics.dart';
import 'package:sleep_app/dreams/viewmodel/statistics_vm.dart';

class statisticsPresenter {
  statisticsModel model = new statisticsModel();

  Map<String, int> getTagsFor(String range) {
    int days = 0;

    switch(range) {
      case "Week":
        days = 7;
        break;
      case "Month":
        days = 30;
        break;
      case "Year":
        days = 365;
        break;
    }

    return model.getTags(days);
    }

  List<TimeOfDay> getHoursFor(String range) {
    int days = 0;

    switch(range) {
      case "Week":
        days = 7;
        break;
      case "Month":
        days = 30;
        break;
      case "Year":
        days = 365;
        break;
    }

    return model.getHours(days);
  }
}


