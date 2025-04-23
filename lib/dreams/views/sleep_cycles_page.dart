import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../contracts/sleep_cycles_contract.dart';
import '../presenter/sleep_cycles_presenter.dart';

class SleepCycles extends StatefulWidget {
  const SleepCycles({super.key});

  @override
  State<SleepCycles> createState() => _SleepCyclesState();
}

class _SleepCyclesState extends State<SleepCycles>
  implements SleepCycleView {
  late SleepCyclePresenter _presenter;
  TimeOfDay? _sleepTime;
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _presenter = SleepCyclePresenter(this);
  }

  @override
  void updateView(TimeOfDay? sleepTime, List<String> suggestions) {
    setState(() {
      _sleepTime = sleepTime;
      _suggestions = suggestions;
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
          InkWell(
            onTap: () => _presenter.pickTime(context),
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