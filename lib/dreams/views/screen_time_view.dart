import 'package:animations/animations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../contracts/screen_time_contract.dart';
import '../models/screen_time_model.dart';
import '../presenter/screen_time_presenter.dart';

class ScreenTimePage extends StatefulWidget {
  const ScreenTimePage({super.key});

  @override
  State<ScreenTimePage> createState() => _ScreenTimePageState();
}

class _ScreenTimePageState extends State<ScreenTimePage> implements ScreenTimeView {
  late ScreenTimePresenter _presenter;
  bool isWeeklyView = false;
  bool isExpanded = true;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _presenter = ScreenTimePresenter(this);
    _presenter.fetchData();
  }

  @override
  void updateView(ScreenTimeModel model) {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void showExportMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CSV Exported!")));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final model = _presenter.model;

    if (model.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Screen Time Overview"),
            backgroundColor: Colors.deepPurpleAccent),
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
            onPressed: () => _presenter.exportCSV(model.appUsageToday, context),
            tooltip: 'Export CSV',
          )
        ],
      ),
      body: PageTransitionSwitcher(
        duration: const Duration (milliseconds: 500),
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
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.deepPurple
                      .shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${model.totalToday.inHours}h ${model.totalToday.inMinutes
                      .remainder(60)}m",
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
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
                  if (isExpanded) _buildPieChart(model),
                ],
              ),
            ),
            _sectionTitle("App Usage Today"),
            ..._buildAppUsageList(model),
            _buildLateNightSuggestions(model),
            _sectionTitle("Peak Usage Hour Today"),
            _infoTile("${_presenter.model.peakHour} (${_presenter.model.peakHourDuration.inMinutes} mins)", isDark),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) =>
      Padding(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 8,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _infoTile(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildLateNightSuggestions(ScreenTimeModel model) {
    final now = DateTime.now();
    if (now.hour < 22) return const SizedBox();
    final heavyApps = model.appUsageToday.entries
        .where((e) => e.value.inMinutes > 60)
        .map((e) => e.key)
        .toList();
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
          const Text("\u23F0 Late Night App Use",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            "You've spent a lot of time on: ${heavyApps.join(', ')}.\nConsider locking these apps to help improve sleep.",
            style: TextStyle(color: _getColorForApp(heavyApps.first)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppUsageList(ScreenTimeModel model) {
    final icons = {
      'YouTube': FontAwesomeIcons.youtube,
      'Instagram': FontAwesomeIcons.instagram,
      'WhatsApp': FontAwesomeIcons.whatsapp,
      'Chrome': FontAwesomeIcons.chrome,
      'Facebook': FontAwesomeIcons.facebook,
      'Other': FontAwesomeIcons.ellipsis,
    };
    final sortedApps = model.appUsageToday.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedApps.map((entry) {
      return ListTile(
        leading: FaIcon(icons[entry.key] ?? FontAwesomeIcons.mobile,
            color: _getColorForApp(entry.key)),
        title: Text(entry.key),
        trailing: Text(
            "${entry.value.inHours}h ${entry.value.inMinutes.remainder(60)}m"),
      );
    }).toList();
  }

  Widget _buildPieChart(ScreenTimeModel model) {
    final totalMinutes = model.appUsageToday.values
        .fold<int>(0, (sum, dur) => sum + dur.inMinutes);
    final chartSections = model.appUsageToday.entries
        .toList()
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == touchedIndex;
      final value = item.value.inMinutes / totalMinutes * 100;
      return PieChartSectionData(
        value: value,
        title:
        "${item.key}\n${item.value.inHours}h ${item.value.inMinutes.remainder(60)}m",
        color: _getColorForApp(item.key),
        radius: isTouched ? 80 : 70,
        titleStyle: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
      );
    }).toList();

    return SizedBox(
      height: 250,
      child: PieChart(
          PieChartData(
          pieTouchData: PieTouchData(
          touchCallback: (event, response) {
    if (!event.isInterestedForInteractions ||
    response == null ||
    response.touchedSection == null) {
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
