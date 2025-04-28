import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'package:sleep_app/dreams/presenter/statistics_presenter.dart';
import '../../components/theme.dart';

void main() => runApp(MaterialApp(
  home: StatisticsPage(),
));

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return GraphTabs();
  }
}

class GraphTabs extends StatefulWidget {
  const GraphTabs({super.key});

  @override
  _GraphTabsState createState() => _GraphTabsState();
}

class _GraphTabsState extends State<GraphTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.buildAppBar(['Quantity', 'Quality'][_selectedIndex]),
      body: BackgroundWrapper(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            QuantityGraphPage(),
            QualityGraphPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time_filled), label: 'Quantity'),
          BottomNavigationBarItem(
              icon: Icon(Icons.sentiment_very_satisfied_rounded), label: 'Quality'),
        ],
      ),
    );
  }
}

class QuantityGraphPage extends StatefulWidget {
  const QuantityGraphPage({super.key});

  @override
  State<QuantityGraphPage> createState() => _QuantityGraphPageState();
}

class _QuantityGraphPageState extends State<QuantityGraphPage> {
  statisticsPresenter presenter = statisticsPresenter();
  String selectedRange = "Week";

  @override
  Widget build(BuildContext context) {
    final List<TimeOfDay> hours = presenter.getHoursFor(selectedRange);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Select Range:", style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedRange,
                      underline: Container(),
                      items: ["Week", "Month", "Year"]
                          .map((range) => DropdownMenuItem(
                                value: range,
                                child: Text(range),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedRange = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: SizedBox(
                width: double.infinity,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BarChart(
                    BarChartData(barGroups: getGroups(hours)),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> getGroups(List<TimeOfDay> hours) {
    List<BarChartGroupData> groupData = [];

    for (int i = 0; i < hours.length; i++) {
      double totalHours = hours[i].hour + hours[i].minute / 60.0;
      groupData.add(generateGroupData(i, totalHours));
    }

    return groupData;
  }

  BarChartGroupData generateGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y, color: Colors.deepPurpleAccent, width: 16),
      ],
    );
  }
}

class QualityGraphPage extends StatefulWidget {
  const QualityGraphPage({super.key});

  @override
  State<QualityGraphPage> createState() => _QualityGraphPageState();
}

class _QualityGraphPageState extends State<QualityGraphPage> {
  statisticsPresenter presenter = statisticsPresenter();
  String selectedRange = "Week";

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.width * 0.35;
    final tags = presenter.getTagsFor(selectedRange);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Select Range:", style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedRange,
                      underline: Container(),
                      items: ["Week", "Month", "Year"]
                          .map((range) => DropdownMenuItem(
                                value: range,
                                child: Text(range),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedRange = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: SizedBox(
                width: 300,
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: getSections(tags, radius),
                    sectionsSpace: 2,
                    centerSpaceRadius: 0,
                    pieTouchData: PieTouchData(enabled: false),
                    startDegreeOffset: 0,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> getSections(Map<String, int> tags, double radius) {
    List<PieChartSectionData> sections = [];
    final random = Random();

    for (var entry in tags.entries) {
      sections.add(PieChartSectionData(
        value: entry.value.toDouble(),
        title: entry.key,
        color: Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256)),
        radius: radius,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
        titlePositionPercentageOffset: 0.5,
      ));
    }

    return sections;
  }
}