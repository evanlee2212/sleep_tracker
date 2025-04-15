abstract class SleepDataContractView {
  void navigateToSleepDiary();
  void navigateToSleepTracker();
  void navigateToSleepRank();
  void navigateToNewSleepEntry();
}

abstract class SleepDataContractPresenter {
  void onSleepDiaryPressed();
  void onSleepTrackerPressed();
  void onSleepRankPressed();
  void onNewSleepEntryPressed();
}