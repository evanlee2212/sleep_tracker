import 'package:flutter/material.dart';

import 'package:sleep_app/dreams/presenter/statistics_presenter.dart';

void main() => runApp(statisticsPage());

class statisticsPage extends StatefulWidget {
  @override
  _statisticsPage createState() => _statisticsPage();
}

class _statisticsPage extends State<statisticsPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: GraphTabs(),
    );

  }
}

class GraphTabs extends StatefulWidget {

  @override
  _GraphTabsState createState() => _GraphTabsState();

}

class _GraphTabsState extends State<GraphTabs> {
  int _selectedIndex = 0;

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(['Quantity', 'Quality'][_selectedIndex]),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            //QuantityGraphPage(),
            //QualityGraphPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.access_time_filled), label: 'Quantity'),
            BottomNavigationBarItem(icon: Icon(Icons.sentiment_very_satisfied_rounded), label: 'Quality'),
          ],
        )
    );
  }
}

class QualityGraphPage extends StatefulWidget {
  @override
  _QualityGraphPageState createState() => _QualityGraphPageState();
}

class _QualityGraphPageState extends State<QualityGraphPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Text("This is the Quality Graph Page"),
    );
  }
}

class QuantityGraphPage extends StatefulWidget {
  @override
  _QuantityGraphPageState createState() => _QuantityGraphPageState();
}

class _QuantityGraphPageState extends State<QuantityGraphPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Text("This is the Quantity Graph Page"),
    );
  }
}