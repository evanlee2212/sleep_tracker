abstract class SleepDataContractView {
  void navigateToSleepDiary();
  void navigateToSleepTracker();
  void navigateToSleepRank();
}

abstract class SleepDataContractPresenter {
  void onSleepDiaryPressed();
  void onSleepTrackerPressed();
  void onSleepRankPressed();
}