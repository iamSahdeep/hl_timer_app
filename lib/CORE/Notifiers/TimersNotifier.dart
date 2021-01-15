import 'package:flutter/cupertino.dart';
import 'package:hl_timer_app/CORE/DataModels/TimerModel.dart';
import 'package:hl_timer_app/CORE/Database/DatabaseManager.dart';

class TimersNotifier extends ChangeNotifier {
  List<TimerModel> allTimers = [];

  TimersNotifier() {
    getTimersFromDatabase();
  }

  getTimersFromDatabase() async {
    allTimers = await DatabaseManager.instance.getAllTimers();
    notifyListeners();
  }
}
