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

class QuantityGraphPage extends StatefulWidget {
  @override
  State<QuantityGraphPage> createState() => _QuantityGraphPageState();
}

class _QuantityGraphPageState extends State<QuantityGraphPage> {
  StatisticsPresenter presenter = StatisticsPresenter();
  String selectedRange = "Week";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(width: 80),
              Text("Select Range:", style: TextStyle(fontSize: 18)),
              SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<String>(
                  value: selectedRange,
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
              ),
            ],
          ),
          SizedBox(height: 20),
          FutureBuilder<List<TimeOfDay>>(
            future: presenter.getHoursFor(selectedRange),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No data available');
              }

              final hours = snapshot.data!;

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: BarChart(
                  BarChartData(barGroups: getGroups(hours)),
                  duration: Duration(milliseconds: 150),
                  curve: Curves.linear,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> getGroups(List<TimeOfDay> hours) {
    List<BarChartGroupData> groupData = [];

    for (int i = 0; i < hours.length; i++) {
      // Convert TimeOfDay to a double (e.g. 14:30 => 14.5)
      double totalHours = hours[i].hour + hours[i].minute / 60.0;
      groupData.add(generateGroupData(i, totalHours));
    }

    return groupData;
  }

  BarChartGroupData generateGroupData(int x, double y) {
    int showingTooltip = -1;

    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
      barRods: [
        BarChartRodData(toY: y),
      ],
    );
  }
}


class QualityGraphPage extends StatefulWidget {
  @override
  State<QualityGraphPage> createState() => _QualityGraphPageState();
}

class _QualityGraphPageState extends State<QualityGraphPage> {
  StatisticsPresenter presenter = StatisticsPresenter();
  String selectedRange = "Week";
  late Map<int, int> futureTags; // <-- FIX HERE

  @override
  void initState() {
    super.initState();
    futureTags = presenter.getTagsFor(selectedRange);
  }

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.width * 0.4;

    final Map<int, int> tags = presenter.getTagsFor(selectedRange);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(width: 80),
              Text("Select Range:", style: TextStyle(fontSize: 18)),
              SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<String>(
                  value: selectedRange,
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
              ),
            ],
          ),
          SizedBox(height: 20),
          tags.isEmpty
              ? Text("No data available")
              : SizedBox(
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
              duration: Duration(milliseconds: 150),
              curve: Curves.linear,
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> getSections(Map<int, int> tags, double radius) {
    List<PieChartSectionData> sections = [];
    final random = Random();

    for (var entry in tags.entries) {
      PieChartSectionData section = PieChartSectionData(
        value: entry.value.toDouble(),
        title: entry.key.toString(),
        color: Color.fromARGB(
            255, random.nextInt(256), random.nextInt(256), random.nextInt(256)),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        titlePositionPercentageOffset: 0.5,
      );

      sections.add(section);
    }

    return sections;
  }
}

