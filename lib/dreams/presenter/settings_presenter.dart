import 'package:sleep_app/dreams/contracts/settings_contract.dart';

class SettingsPresenter {
  final SettingsContractView _view;

  SettingsPresenter(this._view);

  @override
  void onNotificationsPressed() {
    _view.navigateToNotifications();
  }

  @override void onAppThemePressed() {
    _view.swapAppTheme();
  }
}