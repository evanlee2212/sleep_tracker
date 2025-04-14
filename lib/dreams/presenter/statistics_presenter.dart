import 'package:sleep_app/Pages/statistics.dart';
import 'package:sleep_app/dreams/viewmodel/statistics_vm.dart';

class statisticsPresenter {
  statisticsModel model = new statisticsModel();

  Map<String, int> getTags() {
    return model.Tags;
  }
}

