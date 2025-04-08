abstract class SettingsContractView {
  void navigateToNotifications();
  void showError(String message);
}

abstract class SettingsContractPresenter {
  void onNotificationsPressed();
}