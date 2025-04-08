abstract class ResourcesContractView {
  void navigateToSounds();
  void showError(String message);
}

abstract class ResourcesContractPresenter {
  void onSoundsPressed();
}