//import current date
//field to enter sleep hours (enter float)
//sleep quality rating (int 1-5)
//interruption count (enter int)
//sleep details (enter text)
//enter dreams/nightmares (enter text)
//be able to make more dream/nightmare fields
//dream/nightmare radio buttons
import 'package:flutter/material.dart';

class NewSleepEntry extends StatefulWidget {
  const NewSleepEntry({super.key});

  @override
  State<NewSleepEntry> createState() => _NewSleepEntryState();
}

class _NewSleepEntryState extends State<NewSleepEntry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sleep Entry'),
        backgroundColor: Colors.deepPurpleAccent,
        toolbarHeight: 100,
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.pop(context); // Just pop without pushing again
          },
          child: Container(
            height: 60,
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.deepPurpleAccent,
            ),
            child: const Center(
              child: Text(
                'Save Entry',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
