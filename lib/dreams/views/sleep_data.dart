import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/sleepDiary.dart';
import 'package:sleep_app/Pages/sleep_cycles.dart';
import 'package:sleep_app/dreams/views/statistics.dart';
import 'package:sleep_app/Pages/screen_time.dart';
import 'package:sleep_app/components/menu_button.dart';
import 'package:sleep_app/dreams/views/sleepTracker.dart';
import 'package:sleep_app/dreams/contracts/sleep_data_contract.dart';
import 'package:sleep_app/dreams/presenter/sleep_data_presenter.dart';
import '../viewmodel/sleepDiaryModel.dart';
import '../../components/theme.dart'; 

class SleepData extends StatefulWidget {
  const SleepData({super.key});

  @override
  State<SleepData> createState() => _SleepDataState();
}

class _SleepDataState extends State<SleepData> implements SleepDataContractView {
  late final SleepDataPresenter _presenter;
  late final SleepDiaryModel _diaryModel;

  @override
  void initState() {
    super.initState();
    _diaryModel = SleepDiaryModel();
    _presenter = SleepDataPresenter(this, _diaryModel);
  }

  @override
  void navigateToSleepDiary() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SleepDiaryPage(diaryModel: _presenter.diaryModel)),
    );
  }

  @override
  void navigateToSleepTracker() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SleepTracker()),
    );
  }

  @override
  void navigateToSleepCycles() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SleepCycles()),
    );
  }

  @override
  void navigateToSleepStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StatisticsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.buildAppBar('Sleep Data'),
      body: BackgroundWrapper(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              color: Theme.of(context).cardColor,
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MenuButton(
                      text: 'Sleep Diary',
                      onPressed: () => _presenter.onSleepDiaryPressed(),
                    ),
                    const SizedBox(height: 12),
                    MenuButton(
                      text: 'Sleep Tracker',
                      onPressed: () => _presenter.onSleepTrackerPressed(),
                    ),
                    const SizedBox(height: 12),
                    MenuButton(
                      text: 'Sleep Cycles',
                      onPressed: () => _presenter.onSleepCyclesPressed(),
                    ),
                    const SizedBox(height: 12),
                    MenuButton(
                      text: 'Sleep Statistics',
                      onPressed: () => _presenter.onSleepStatisticsPressed(),
                    ),
                    const SizedBox(height: 12),
                    MenuButton(
                      text: 'Screen Time',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ScreenTimePage()),
                        );
                      },
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
