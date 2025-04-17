import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animations/animations.dart';
import 'package:usage_stats/usage_stats.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ScreenTimePage extends StatefulWidget {
  const ScreenTimePage({super.key});

  @override
  State<ScreenTimePage> createState() => _ScreenTimePageState();
}

class _ScreenTimePageState extends State<ScreenTimePage> {
  Duration totalToday = Duration.zero;
  Map<String, Duration> appUsageToday = {};
  String peakHour = '-';
  Duration peakHourDuration = Duration.zero;
  bool isLoading = true;
  bool isWeeklyView = false;
  bool isExpanded = true;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchScreenTimeData();
  }

  Future<void> fetchScreenTimeData() async {
    final hasPermission = await UsageStats.checkUsagePermission();
    if (hasPermission != true) {
      await UsageStats.grantUsagePermission();
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
        if (stat.packageName == null || stat.totalTimeInForeground == null) continue;

        final duration = Duration(milliseconds: int.tryParse(stat.totalTimeInForeground!) ?? 0);
        final appName = stat.packageName!.split('.').last;

        if (duration == Duration.zero) continue;

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

      if (mounted) {
        setState(() {
          totalToday = total;
          appUsageToday = appUsages;
          peakHour = "${peak.key}:00";
          peakHourDuration = peak.value;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Usage stats error: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> exportCSV() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/screen_time_export.csv');
    final buffer = StringBuffer();
    buffer.writeln('App,Usage (minutes)');
    appUsageToday.forEach((app, duration) {
      buffer.writeln('$app,${duration.inMinutes}');
    });
    await file.writeAsString(buffer.toString());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("CSV Exported!")));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Screen Time Overview"), backgroundColor: Colors.deepPurpleAccent),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen Time Overview'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: exportCSV,
            tooltip: 'Export CSV',
          )
        ],
      ),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 500),
        reverse: !isWeeklyView,
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: ListView(
          key: ValueKey<bool>(isWeeklyView),
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Text(
                "Today's Total Screen Time",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${totalToday.inHours}h ${totalToday.inMinutes.remainder(60)}m",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Usage Breakdown"),
                  if (isExpanded) _buildPieChart(),
                ],
              ),
            ),
            _sectionTitle("App Usage Today"),
            ..._buildAppUsageList(),
            _buildLateNightSuggestions(),
            _sectionTitle("Peak Usage Hour Today"),
            _infoTile("$peakHour (${peakHourDuration.inMinutes} mins)", isDark),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  );

  Widget _infoTile(String content, bool isDark) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? Colors.grey.shade800 : Colors.deepPurple.shade50,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(content, style: const TextStyle(fontSize: 18)),
  );

  Widget _buildLateNightSuggestions() {
    final now = DateTime.now();
    if (now.hour < 22) return const SizedBox();
    final heavyApps = appUsageToday.entries.where((e) => e.value.inMinutes > 60).map((e) => e.key).toList();
    if (heavyApps.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("\u23F0 Late Night App Use", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text("You've spent a lot of time on: ${heavyApps.join(', ')}.\nConsider locking these apps to help improve sleep."),
        ],
      ),
    );
  }

  List<Widget> _buildAppUsageList() {
    final icons = {
      'YouTube': FontAwesomeIcons.youtube,
      'Instagram': FontAwesomeIcons.instagram,
      'WhatsApp': FontAwesomeIcons.whatsapp,
      'Chrome': FontAwesomeIcons.chrome,
      'Other': FontAwesomeIcons.ellipsis,
    };
    final sortedApps = appUsageToday.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sortedApps.map((entry) {
      return ListTile(
        leading: FaIcon(icons[entry.key] ?? FontAwesomeIcons.mobile, color: Colors.deepPurpleAccent),
        title: Text(entry.key),
        trailing: Text("${entry.value.inHours}h ${entry.value.inMinutes.remainder(60)}m"),
      );
    }).toList();
  }

  Widget _buildPieChart() {
    final totalMinutes = appUsageToday.values.fold<int>(0, (sum, dur) => sum + dur.inMinutes);
    final chartSections = appUsageToday.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == touchedIndex;
      final value = item.value.inMinutes / totalMinutes * 100;
      return PieChartSectionData(
        value: value,
        title: "${item.key}\n${item.value.inHours}h ${item.value.inMinutes.remainder(60)}m",
        color: _getColorForApp(item.key),
        radius: isTouched ? 80 : 70,
        titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
      );
    }).toList();

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              if (!event.isInterestedForInteractions || response == null || response.touchedSection == null) {
                setState(() => touchedIndex = -1);
                return;
              }
              setState(() => touchedIndex = response.touchedSection!.touchedSectionIndex);
            },
          ),
          sections: chartSections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  Color _getColorForApp(String appName) {
    switch (appName) {
      case 'YouTube':
        return Colors.redAccent;
      case 'Instagram':
        return Colors.purpleAccent;
      case 'WhatsApp':
        return Colors.greenAccent;
      case 'Chrome':
        return Colors.blueAccent;
      case 'Other':
        return Colors.grey;
      default:
        return Colors.deepPurpleAccent;
    }
  }
}
