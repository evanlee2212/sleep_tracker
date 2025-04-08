import 'package:sleep_app/dreams/contracts/settings_contract.dart';

class SettingsPresenter {
  final SettingsContractView _view;

  SettingsPresenter(this._view);

  @override
  void onNotificationsPressed() {
    try {
      _view.navigateToNotifications();
    } catch (e) {
      _view.showError('Could not open Notification Settings');
    }
  }
}