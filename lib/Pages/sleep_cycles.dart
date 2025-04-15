//import current date
//field to enter sleep hours (enter float)
//sleep quality rating based on hours of sleep inputted,
// amount of interruptions, and
// sleep cycles passed during sleep (int 1-10)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewSleepEntry extends StatefulWidget {
  const NewSleepEntry({super.key});

  @override
  State<NewSleepEntry> createState() => _NewSleepEntryState();
}

class _NewSleepEntryState extends State<NewSleepEntry> {
  TimeOfDay? _sleepTime;
  List<String> _suggestions = [];

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _sleepTime = picked;
        _suggestions = _generateSuggestions(picked);
      });
    }
  }

  List<String> _generateSuggestions(TimeOfDay time) {
    final now = DateTime.now();
    final baseTime = DateTime(now.year, now.month, now.day, time.hour, time.minute)
        .add(const Duration(minutes: 15)); // add 15 mins to fall asleep

    return List.generate(4, (i) {
      final suggestionTime = baseTime.add(Duration(minutes: 90 * ((i+1) + 3))); // 3 to 6 cycles
      return DateFormat.jm().format(suggestionTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Time Suggestions'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 🔘 Sleep Suggestion Button (NEW)
            InkWell(
              onTap: _pickTime,
              child: Container(
                height: 60,
                width: 250,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.deepPurpleAccent,
                ),
                child: const Center(
                  child: Text(
                    'Sleep Time Suggestion',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const Text(
              'Pick the time you plan to go to sleep:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            if (_sleepTime != null) ...[
              Text(
                'Sleep Time: ${_sleepTime!.format(context)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Suggested alarm times to wake up feeling refreshed:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                '(These are suggestions based on 90-minute sleep cycles)',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 10),
              for (var time in _suggestions)
                ListTile(
                  leading: const Icon(Icons.alarm),
                  title: Text(time),
                ),
            ]
          ],
        ),
      ),
    );
  }
}
