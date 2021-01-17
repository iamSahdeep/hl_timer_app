import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hl_timer_app/CORE/DataModels/TimerModel.dart';
import 'package:hl_timer_app/CORE/Database/DatabaseManager.dart';
import 'package:hl_timer_app/CORE/Helpers/Utils.dart';

class TaskScreen extends StatefulWidget {
  final TimerModel timerModel;

  const TaskScreen({Key key, this.timerModel}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  Timer timer;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    duration = Duration(seconds: widget.timerModel.timeLeft);
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.timerModel.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(widget.timerModel.description,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20)),
            if (widget.timerModel.status != -1)
              Text(Utils.getFormattedDuration(duration),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            if (widget.timerModel.status == -1)
              Text("Completed",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            if (widget.timerModel.status != -1)
              RaisedButton(
                onPressed: () {
                  if (widget.timerModel.status == 0) {
                    timer.cancel();
                    setState(() {
                      widget.timerModel.setStatus(1);
                    });
                  } else if (widget.timerModel.status == 1) {
                    setState(() {
                      timer.cancel();
                      startTimer();
                      widget.timerModel.setStatus(0);
                    });
                  }
                },
                child: Text(widget.timerModel.status == 0 ? "Stop" : "Resume"),
              )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = new Timer.periodic(Duration(seconds: 1), (timer) {
      if (duration == Duration.zero || widget.timerModel.status == -1) {
        setState(() {
          widget.timerModel.setStatus(-1);
          DatabaseManager.instance.updateTimer(widget.timerModel);
        });
        timer.cancel();
        return;
      }

      if (widget.timerModel.status == 0) {
        setState(() {
          duration = Duration(seconds: duration.inSeconds - 1);
        });

        widget.timerModel.setTimeLeft(duration.inSeconds);
        DatabaseManager.instance.updateTimer(widget.timerModel);
      }
    });
  }
}
