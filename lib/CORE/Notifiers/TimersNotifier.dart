import 'package:flutter/cupertino.dart';
import 'package:hl_timer_app/CORE/DataModels/TimerModel.dart';

class TimersNotifier extends ChangeNotifier {
  List<TimerModel> allTimers = [];

  getTimersFromDatabase() {
    notifyListeners();
  }
}
