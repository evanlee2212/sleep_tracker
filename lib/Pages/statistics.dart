import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'package:sleep_app/dreams/presenter/statistics_presenter.dart';

void main() => runApp(MaterialApp(
  home: StatisticsPage(),
));

class StatisticsPage extends StatefulWidget {
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
  @override
  _GraphTabsState createState() => _GraphTabsState();
}

class _GraphTabsState extends State<GraphTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(['Quantity', 'Quality'][_selectedIndex]),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          QuantityGraphPage(),
          QualityGraphPage(),
        ],
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

class QuantityGraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("This is the Quantity Graph Page"),
    );
  }
}

class QualityGraphPage extends StatelessWidget {
  statisticsPresenter presenter = new statisticsPresenter();

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.width * 0.4;
    return Center(
      child: SizedBox(
        width: 1000,
        height: 1000,
        child: PieChart(
          PieChartData(
            sections: getSections(presenter.getTags(), radius),
            sectionsSpace: 2,
            centerSpaceRadius: 0,
            pieTouchData: PieTouchData(enabled: false),
            startDegreeOffset: 0,
          ),
          duration: Duration(milliseconds: 150),
          curve: Curves.linear,
        ),
      ),
    );
  }

  List<PieChartSectionData> getSections(Map<String, int> tags, double radius){
    List<PieChartSectionData> sections = [];
    final random = Random();
    int total = 0;

    for (var entry in tags.values){
      total += entry;
    }

    for (var entry in tags.entries) {
      PieChartSectionData section = PieChartSectionData(
        value: entry.value.toDouble(),
        title: entry.key,
        color: Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256)),
        radius: radius,
      );

      sections.add(section);
    }

    return sections;
  }
}


