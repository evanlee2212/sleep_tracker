abstract class SleepDataContractView {
  void navigateToSleepDiary();
  void navigateToSleepTracker();
  void navigateToSleepStatistics();
  void navigateToSleepCycles();
  void navigateToScreenTime();
}

abstract class SleepDataContractPresenter {
  void onSleepDiaryPressed();
  void onSleepTrackerPressed();
  void onSleepStatisticsPressed();
  void onSleepCyclesPressed();
  void onScreenTimePressed();
}