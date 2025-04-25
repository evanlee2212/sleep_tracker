import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/sleepDiary.dart';
import 'package:sleep_app/dreams/views/sleep_cycles_page.dart';
import 'package:sleep_app/Pages/statistics.dart';
import 'package:sleep_app/dreams/views/screen_time_view.dart';
import 'package:sleep_app/components/menu_button.dart';
import 'package:sleep_app/Pages/sleepTracker.dart';
import 'package:sleep_app/dreams/contracts/sleep_data_contract.dart';
import 'package:sleep_app/dreams/presenter/sleep_data_presenter.dart';
import '../viewmodel/sleepDiaryModel.dart';

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
  void navigateToScreenTime() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScreenTimePage()),
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
      appBar: AppBar(
        title: const Text('Sleep Data'),
        backgroundColor: Colors.deepPurpleAccent,
        toolbarHeight: 100,
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuButton(
                text: 'Sleep Diary',
                onPressed: () => _presenter.onSleepDiaryPressed(),
              ),
              const SizedBox(height: 10),
              MenuButton(
                text: 'Sleep Tracker',
                onPressed: () => _presenter.onSleepTrackerPressed(),
              ),
              const SizedBox(height: 10),
              MenuButton(
                text: 'Sleep Cycles',
                onPressed: () => _presenter.onSleepCyclesPressed(),
              ),
              const SizedBox(height: 10),
              MenuButton(
                text: 'Sleep Statistics',
                onPressed: () => _presenter.onSleepStatisticsPressed(),
              ),
              const SizedBox(height: 10),
              MenuButton(
                text: 'Screen Time',
                onPressed: () => _presenter.onScreenTimePressed(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
