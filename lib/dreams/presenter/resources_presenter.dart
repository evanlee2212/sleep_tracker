import 'package:sleep_app/dreams/contracts/resources_contract.dart';

class ResourcesPresenter {
  final ResourcesContractView _view;

  ResourcesPresenter(this._view);

  @override
  void onSoundsPressed() {
    _view.navigateToSounds();
  }

  @override
  void onVideosPressed() {
    _view.navigateToVideos();
  }
}