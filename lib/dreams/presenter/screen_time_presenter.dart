import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:flutter/material.dart';
import 'package:sleep_app/dreams/models/screen_time_model.dart';
import 'package:sleep_app/dreams/contracts/screen_time_contract.dart';

class ScreenTimePresenter {
  late ScreenTimeModel _model;
  late ScreenTimeView _view;

  ScreenTimePresenter(ScreenTimeView view) {
    _view = view;
    _model = ScreenTimeModel();

  }

  ScreenTimeModel get model => _model;

  Future<void> fetchData() async {
    final hasPermission = await UsageStats.checkUsagePermission();
    if (hasPermission != true) {
      await UsageStats.grantUsagePermission();
      _view.updateView(_model);
      return;
    }

    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day);

    try {
      List<UsageInfo> usageStats = await UsageStats.queryUsageStats(startDate, endDate);

      final Map<String, Duration> appUsages = {};
      Duration total = Duration.zero;
      final hourMap = Map<int, Duration>.fromIterable(List.generate(24, (i) => i), value: (_) => Duration.zero);

      for (var stat in usageStats) {
        if (stat.packageName == null || stat.totalTimeInForeground == null) {
          continue;
        }

        final duration = Duration(milliseconds: int.tryParse(stat.totalTimeInForeground!) ?? 0);
        final appName = stat.packageName!.split('.').last;

        if (duration == Duration.zero) {
          continue;
        }

        appUsages.update(appName, (existing) => existing + duration, ifAbsent: () => duration);
        total += duration;

        final hour = stat.lastTimeUsed != null
            ? DateTime.fromMillisecondsSinceEpoch(int.tryParse(stat.lastTimeUsed!) ?? 0).hour
            : null;

        if (hour != null) {
          hourMap[hour] = hourMap[hour]! + duration;
        }
      }

      final peak = hourMap.entries.reduce((a, b) => a.value > b.value ? a : b);

      _model.totalToday = total;
      _model.appUsageToday = appUsages;
      _model.peakHour = "${peak.key}:00";
      _model.peakHourDuration = peak.value;
      _model.isLoading = false;
      _view.updateView(_model);
    } catch (e) {
      print("Usage stats error: $e");
      _model.isLoading = false;
      _view.updateView(_model);
    }
  }

  Future<void> exportCSV(Map<String, Duration> appUSageToday, BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/screen_time_export.csv');
    final buffer = StringBuffer();
    buffer.writeln('App,Usage (minutes)');
    appUSageToday.forEach((app, duration) {
      buffer.writeln('$app,${duration.inMinutes}');
    });
    await file.writeAsString(buffer.toString());
    _view.showExportMessage(context);
  }
}