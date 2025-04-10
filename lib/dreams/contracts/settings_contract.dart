abstract class SettingsContractView {
  void navigateToNotifications();
  void swapAppTheme();
}

abstract class SettingsContractPresenter {
  void onNotificationsPressed();
  void onAppThemePressed();
}