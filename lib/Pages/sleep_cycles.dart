import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/theme.dart';

class SleepCycles extends StatefulWidget {
  const SleepCycles({super.key});

  @override
  State<SleepCycles> createState() => _NewSleepEntryState();
}

class _NewSleepEntryState extends State<SleepCycles> {
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
        .add(const Duration(minutes: 15));

    return List.generate(4, (i) {
      final suggestionTime = baseTime.add(Duration(minutes: 90 * ((i + 1) + 3)));
      return DateFormat.jm().format(suggestionTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.buildAppBar('Sleep Time Suggestions'),
      body: BackgroundWrapper(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: _pickTime,
                          style: AppTheme.elevatedButtonStyle,
                          child: const Text(
                            'Sleep Time Suggestion',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                          ..._suggestions.map((time) => Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.alarm, color: Colors.deepPurpleAccent),
                                  title: Text(time, style: const TextStyle(fontSize: 16)),
                                ),
                              )),
                        ]
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}