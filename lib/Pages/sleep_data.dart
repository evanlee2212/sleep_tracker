//provide overview of sleep quality for each day in month
//determined by hours, nightmares/dreams, interruptions, etc.
import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/new_sleep_entry.dart';



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
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewSleepEntry()));

          },
          child: Container(
            height: 60,
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.deepPurpleAccent,
            ),
            child: Center(child: Text('New Sleep Entry', style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ))),
          ),
        ),
      ),
    );
  }
}