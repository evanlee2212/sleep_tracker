import 'package:flutter/cupertino.dart';
import '../models/screen_time_model.dart';

abstract class ScreenTimeView {
  void updateView(ScreenTimeModel model);
  void showExportMessage(BuildContext context);
}