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
  void onNewSleepEntryPressed(){
    _view.navigateToNewSleepEntry();
  }

  @override
  void onSleepRankPressed() {
    _view.navigateToSleepRank();
  }

  SleepDiaryModel get diaryModel => _diaryModel;
}