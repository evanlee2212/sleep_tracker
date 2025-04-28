import 'package:flutter/material.dart';
import 'package:sleep_app/dreams/viewmodel/statistics_vm.dart';

class StatisticsPresenter {
  final StatisticsModel model = StatisticsModel();

  Map<int, int> getTagsFor(String range) {
    int days = 0;

    switch (range) {
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

    final filteredLogs = model.getQuality(days);

    Map<int, int> qualityCounts = {};

    for (var log in filteredLogs) {
      final qualityString = log['quality'];
      if (qualityString == null || qualityString.isEmpty) continue;

      final cleanedQuality = qualityString.split('/').first.trim();

      final quality = int.tryParse(cleanedQuality);
      if (quality == null) continue;

      qualityCounts[quality] = (qualityCounts[quality] ?? 0) + 1;
    }

    return qualityCounts;
  }

  Future<List<TimeOfDay>> getHoursFor(String range) async {
    await model.fetchData();

    int days = 0;
    switch (range) {
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





