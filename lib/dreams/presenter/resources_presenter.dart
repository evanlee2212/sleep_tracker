import 'package:sleep_app/dreams/contracts/resources_contract.dart';

class ResourcesPresenter {
  final ResourcesContractView _view;

  ResourcesPresenter(this._view);

  @override
  void onSoundsPressed() {
    try {
      _view.navigateToSounds();
    } catch (e) {
      _view.showError('Could not open Sounds');
    }
  }
}