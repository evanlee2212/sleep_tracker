//create a log that tracks each time the sleep tracker is used and saved the time the user has been asleep on the same page
import 'package:flutter/material.dart';
import 'package:sleep_app/dreams/views/sleepDiary.dart';
import 'dart:async';

import 'package:sleep_app/dreams/presenter/sleepTracker_presenter.dart';
import 'package:sleep_app/dreams/viewmodel/sleepDiaryModel.dart';
import '../../components/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class SleepTracker extends StatefulWidget {
  const SleepTracker({super.key});

  @override
  State<SleepTracker> createState() => _SleepTrackerState();
}

class _SleepTrackerState extends State<SleepTracker> {
  sleepTrackerPresenter presenter = sleepTrackerPresenter();
  bool _isPlaying = false;
  Timer? _timer;
  int _elapsedTime = 0;

  @override
  void initState() {
    super.initState();
    presenter.fetchEntries().then((_) {
      setState(() {});
    });
  }

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
      final durationInHours = (_elapsedTime / 3600).toStringAsFixed(2);
      _getSleepQualityAndLog(durationInHours);
    }
  }

  Future<void> _getSleepQualityAndLog(String duration) async {
    int? selectedQuality = await _showSleepQualityDialog();

    if (selectedQuality != null) {
      _logSleepSession(duration, selectedQuality);
      _showSleepDuration(duration, selectedQuality);
    }
  }

  Future<int?> _showSleepQualityDialog() async {
    int selected = 5;

    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Rate How You Slept (1-10)", style: GoogleFonts.poppins()),
          content: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Slider(
                  value: selected.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: "$selected",
                  onChanged: (value) {
                    setState(() {
                      selected = value.toInt();
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(selected),
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _logSleepSession(String durationInHours, int sleepQuality) {
    setState(() {
      presenter.addSleepLog(durationInHours, sleepQuality);
    });
    _elapsedTime = 0;
  }

  void _showSleepDuration(String durationInHours, int quality) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sleep Summary'),
        content: Text('You slept for $durationInHours hours.\nSleep quality: $quality/10\nAdd to Sleep Diary?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Not now'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SleepDiaryPage(
                    diaryModel: SleepDiaryModel(),
                  ),
                ),
              );
            },
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
      appBar: AppTheme.buildAppBar('Sleep Tracker'),
      body: BackgroundWrapper(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Card(
              color: Colors.white.withOpacity(0.95),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Track Sleep Duration & Quality', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          key: const Key('play button'),
                          onPressed: _isPlaying ? null : _startTimer,
                          iconSize: 50.0,
                          icon: const Icon(Icons.play_arrow),
                          color: color,
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          key: const Key('stop button'),
                          onPressed: _isPlaying ? _stopTimer : null,
                          iconSize: 50.0,
                          icon: const Icon(Icons.stop),
                          color: color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text('Sleep Log', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(height: 30, thickness: 1.5),
                    SizedBox(
                      height: 400,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: presenter.getSleepLogsLength(),
                        itemBuilder: (context, index) {
                          final log = presenter.getLog(index);
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                            child: ListTile(
                              leading: const Icon(Icons.bedtime, color: Colors.deepPurpleAccent),
                              title: Text('Duration: ${log['duration']}', style: GoogleFonts.poppins()),
                              subtitle: Text('Time: ${log['time']}\nQuality: ${log['quality']}/10', style: GoogleFonts.poppins()),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
