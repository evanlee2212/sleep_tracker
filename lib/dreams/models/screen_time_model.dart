import 'package:usage_stats/usage_stats.dart';

class ScreenTimeModel {
  Duration totalToday = Duration.zero;
  Map<String, Duration> appUsageToday = {};
  String peakHour = '-';
  Duration peakHourDuration = Duration.zero;
  bool isLoading = true;
}