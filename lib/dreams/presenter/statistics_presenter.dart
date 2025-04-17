import 'package:sleep_app/Pages/statistics.dart';
import 'package:sleep_app/dreams/viewmodel/statistics_vm.dart';

class statisticsPresenter {
  statisticsModel model = statisticsModel();

  Map<String, int> getTagsFor(String range) {
    int days = 0;

    switch(range) {
      case "Week":
        days = 7;
        break;
      case "Month":
        days = 30;
        break;
      case "Year":
        days = 365;
        break;
    }

    return model.getTags(days);
    }
}


