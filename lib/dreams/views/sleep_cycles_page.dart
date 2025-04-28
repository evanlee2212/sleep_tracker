import 'package:flutter/material.dart';
import '../../components/theme.dart';
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
      appBar: AppTheme.buildAppBar('Sleep Time Suggestions'),
      body: BackgroundWrapper(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: AppTheme.elevatedButtonStyle,
                    onPressed: () => _presenter.pickTime(context),
                    child: const Text('Pick Sleep Time'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pick the time you plan to go to sleep:',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (_sleepTime != null) ...[
                    Text(
                      'Selected Sleep Time: ${_sleepTime!.format(context)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Suggested alarm times to wake up feeling refreshed:',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '(Based on 90-minute sleep cycles)',
                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16),
                    ..._suggestions.map((time) => Card(
                          color: Colors.white.withOpacity(0.9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.alarm),
                            title: Text(time),
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
