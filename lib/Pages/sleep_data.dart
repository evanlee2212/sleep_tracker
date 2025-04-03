//provide overview of sleep quality for each day in month
//determined by hours, nightmares/dreams, interruptions, etc.
import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/new_sleep_entry.dart';
import 'package:sleep_app/components/menu_button.dart';


class SleepData extends StatefulWidget {
  const SleepData({super.key});

  @override
  State<SleepData> createState() => _SleepDataState();
}

class _SleepDataState extends State<SleepData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sleep Data'
        ),
        backgroundColor: Colors.deepPurpleAccent,
        toolbarHeight: 100,

      ),
      body: Center(
      ),
    );
  }
}