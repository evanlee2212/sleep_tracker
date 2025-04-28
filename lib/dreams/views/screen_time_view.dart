import 'package:flutter/material.dart';
import '../../components/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../contracts/screen_time_contract.dart';
import '../models/screen_time_model.dart';
import '../presenter/screen_time_presenter.dart';
import 'package:animations/animations.dart';

class ScreenTimePage extends StatefulWidget {
  const ScreenTimePage({super.key});

  @override
  State<ScreenTimePage> createState() => _ScreenTimePageState();
}

class _ScreenTimePageState extends State<ScreenTimePage> implements ScreenTimeView {
  late ScreenTimePresenter _presenter;
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
    if (mounted) setState(() {});
  }

  @override
  void showExportMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("CSV Exported!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = _presenter.model;

    return Scaffold(
      appBar: AppTheme.buildAppBar('Screen Time Overview'),
      body: BackgroundWrapper(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: model.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle("Today's Total Screen Time"),
                        const SizedBox(height: 8),
                        _infoTile("${model.totalToday.inHours}h ${model.totalToday.inMinutes.remainder(60)}m"),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: AppTheme.elevatedButtonStyle,
                          onPressed: () => _presenter.exportCSV(model.appUsageToday, context),
                          child: const Text('Export CSV'),
                        ),
                        const SizedBox(height: 24),
                        _sectionTitle("Usage Breakdown"),
                        const SizedBox(height: 12),
                        if (isExpanded) _buildPieChart(model),
                        const SizedBox(height: 24),
                        _sectionTitle("App Usage Today"),
                        ..._buildAppUsageList(model),
                        const SizedBox(height: 24),
                        _buildLateNightSuggestions(model),
                        const SizedBox(height: 24),
                        _sectionTitle("Peak Usage Hour Today"),
                        const SizedBox(height: 8),
                        _infoTile("${model.peakHour} (${model.peakHourDuration.inMinutes} mins)"),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      );

  Widget _infoTile(String text) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );

  Widget _buildPieChart(ScreenTimeModel model) {
    final totalMinutes = model.appUsageToday.values.fold<int>(0, (sum, dur) => sum + dur.inMinutes);
    final chartSections = model.appUsageToday.entries.toList().asMap().entries.map((entry) {
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

  List<Widget> _buildAppUsageList(ScreenTimeModel model) {
    final sortedApps = model.appUsageToday.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedApps.map((entry) {
      return OpenContainer(
        transitionType: ContainerTransitionType.fade,
        closedElevation: 4,
        closedColor: Colors.white,
        closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        openBuilder: (context, _) => Scaffold(
          appBar: AppTheme.buildAppBar(entry.key),
          body: Center(
            child: Text(
              "You used ${entry.key} for ${entry.value.inHours}h ${entry.value.inMinutes.remainder(60)}m today!",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        closedBuilder: (context, openContainer) => ListTile(
          onTap: openContainer,
          leading: FaIcon(_getIconForApp(entry.key), color: _getColorForApp(entry.key)),
          title: Text(entry.key),
          trailing: Text("${entry.value.inHours}h ${entry.value.inMinutes.remainder(60)}m"),
        ),
      );
    }).toList();
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
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("\u23F0 Late Night App Use", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            "You have been using: ${heavyApps.join(", ")}.\nConsider limiting them before bed.",
            style: const TextStyle(color: Colors.black87),
          ),
        ],
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
      default:
        return Colors.deepPurpleAccent;
    }
  }

  IconData _getIconForApp(String appName) {
    switch (appName) {
      case 'YouTube':
        return FontAwesomeIcons.youtube;
      case 'Instagram':
        return FontAwesomeIcons.instagram;
      case 'WhatsApp':
        return FontAwesomeIcons.whatsapp;
      case 'Chrome':
        return FontAwesomeIcons.chrome;
      default:
        return FontAwesomeIcons.mobileScreenButton;
    }
  }
}
