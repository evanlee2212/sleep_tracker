import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:usage_stats/usage_stats.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../components/theme.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.buildAppBar('Screen Time Overview'),
      body: BackgroundWrapper(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Card(
              color: Colors.white.withOpacity(0.95),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Today's Screen Time",
                      style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _infoTile("Total Time: ${totalToday.inHours}h ${totalToday.inMinutes.remainder(60)}m"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: exportCSV,
                      style: AppTheme.elevatedButtonStyle,
                      child: const Text('Export CSV'),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => setState(() => isExpanded = !isExpanded),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _sectionTitle("Usage Breakdown"),
                          const SizedBox(height: 10),
                          if (isExpanded) _buildPieChart(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _sectionTitle("Peak Usage Hour Today"),
                    const SizedBox(height: 10),
                    _infoTile("$peakHour (${peakHourDuration.inMinutes} mins)"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(text, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600)),
      );

  Widget _infoTile(String content) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(content, style: GoogleFonts.poppins(fontSize: 18)),
      );

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
        titleStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
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

Future<void> exportCSV() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/screen_time_export.csv');
    final buffer = StringBuffer();
    buffer.writeln('App,Usage (minutes)');
    appUsageToday.forEach((app, duration) {
      buffer.writeln('$app,${duration.inMinutes}');
    });
    await file.writeAsString(buffer.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Your screen time data has been exported successfully!', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: GoogleFonts.poppins(color: Colors.deepPurple)),
          ),
        ],
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to export CSV: $e')),
    );
  }
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
      default:
        return Colors.deepPurpleAccent;
    }
  }
}
