import 'package:flutter/material.dart';
import 'package:hl_timer_app/CORE/Notifiers/TimersNotifier.dart';
import 'package:hl_timer_app/UI/Widgets/TimerListItem.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimersNotifier>(
      create: (cxt) => TimersNotifier(),
      child: Consumer(builder: (cxt, TimersNotifier notifier, _) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Timer App",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          body: notifier.allTimers.isEmpty
              ? Center(
                  child: Text("No Data Found"),
                )
              : ListView.builder(
                  itemCount: notifier.allTimers.length,
                  itemBuilder: (cxt, index) {
                    return TimerListItem(timerModel: notifier.allTimers[index]);
                  }),
        );
      }),
    );
  }
}
