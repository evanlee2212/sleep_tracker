import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/sleepDiary.dart';
import 'package:sleep_app/Pages/sleepRank.dart';
import 'package:sleep_app/Pages/sleep_cycles.dart';
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => SleepDiaryPage(diaryModel: _presenter.diaryModel)));
  }

  @override
  void navigateToSleepTracker() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SleepTracker()));
  }
  @override
  void navigateToNewSleepEntry(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewSleepEntry()));
  }
  @override
  void navigateToSleepRank() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SleepRank()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Sleep Data'
        ),
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
                onPressed: () => _presenter.onNewSleepEntryPressed(),
              ),
              const SizedBox(height: 10),
              MenuButton(
                text: 'Sleep Rank',
                onPressed: () => _presenter.onSleepRankPressed(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}