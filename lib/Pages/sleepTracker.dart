//create a log that tracks each time the sleep tracker is used and saved the time the user has been asleep on the same page
import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';

class SleepTracker extends StatefulWidget {
  const SleepTracker({super.key});

  @override
  State<SleepTracker> createState() => _SleepTrackerState();
}

class _SleepTrackerState extends State<SleepTracker> {
  bool _isPlaying = false;
  Timer? _timer;
  final int _sleepRank = 10;
  int _elapsedTime = 0; // In seconds for simplicity

  // 🆕 List to track sleep logs
  List<Map<String, String>> _sleepLogs = [];

  void _startTimer() {
    setState(() {
      _isPlaying = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _isPlaying = false;
      });
      final durationInHours = (_elapsedTime / 10).toStringAsFixed(2);
      _logSleepSession(durationInHours); // Pass it as parameter
      _showSleepDuration(durationInHours);
    }
  }

  void _logSleepSession(String durationInHours) {
    final now = DateTime.now();
    setState(() {
      _sleepLogs.add({
        'time': '${now.hour}:${now.minute.toString().padLeft(2, '0')} - ${now.month}/${now.day}',
        'duration': '$durationInHours hrs'
      });
      _elapsedTime = 0; // Reset AFTER everything is stored
    });
  }

  void _showSleepDuration(String durationInHours) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sleep Duration'),
        content: Text('You slept for $durationInHours hours.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  void _sleepQualityInput() {
    // Future enhancement: input sleep quality from user
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Tracker')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Center(child: Text('Track Sleep Duration & Quality Below.')),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                key: const Key('play button'),
                onPressed: _isPlaying ? null : _startTimer,
                iconSize: 48.0,
                icon: const Icon(Icons.play_arrow),
                color: color,
              ),
              IconButton(
                key: const Key('stop button'),
                onPressed: _isPlaying ? _stopTimer : null,
                iconSize: 48.0,
                icon: const Icon(Icons.stop),
                color: color,
              ),
            ],
          ),
          const Divider(height: 40),
          const Text('Sleep Log:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: _sleepLogs.length,
              itemBuilder: (context, index) {
                final log = _sleepLogs[index];
                return ListTile(
                  leading: const Icon(Icons.bedtime),
                  title: Text('Duration: ${log['duration']}'),
                  subtitle: Text('Time: ${log['time']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//Still need to implement these for user story 1