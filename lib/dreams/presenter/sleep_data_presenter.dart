import 'package:sleep_app/dreams/contracts/sleep_data_contract.dart';
import 'package:sleep_app/dreams/viewmodel/sleepDiaryModel.dart';

class SleepDataPresenter implements SleepDataContractPresenter {
  final SleepDataContractView _view;
  final SleepDiaryModel _diaryModel;

  SleepDataPresenter(this._view, this._diaryModel);

  @override
  void onSleepDiaryPressed() {
    _view.navigateToSleepDiary();
  }

  @override
  void onSleepTrackerPressed() {
    _view.navigateToSleepTracker();
  }

  @override
  void onSleepCyclesPressed(){
    _view.navigateToSleepCycles();
  }

  @override
  void onSleepStatisticsPressed() {
    _view.navigateToSleepStatistics();
  }

  @override
  void onScreenTimePressed() {
    _view.navigateToScreenTime();
  }

  SleepDiaryModel get diaryModel => _diaryModel;
}