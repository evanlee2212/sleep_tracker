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
  int _elapsedTime = 0; // In seconds for simplicity

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
      _showSleepDuration();
    }
  }

  void _showSleepDuration() {
    final durationInHours = (_elapsedTime / 10).toStringAsFixed(2); // 10 seconds = 1 hour
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

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Tracker')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('Track Sleep Duration Below.')),
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
        ],
      ),
    );
  }
}
//Still need to implement these for user story 1