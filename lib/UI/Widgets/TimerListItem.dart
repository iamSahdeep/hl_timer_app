import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hl_timer_app/CORE/DataModels/TimerModel.dart';
import 'package:hl_timer_app/CORE/Database/DatabaseManager.dart';
import 'package:hl_timer_app/CORE/Helpers/Utils.dart';
import 'package:hl_timer_app/UI/Screens/TaskScreen.dart';

class TimerListItem extends StatefulWidget {
  final TimerModel timerModel;

  const TimerListItem({Key key, this.timerModel}) : super(key: key);

  @override
  _TimerListItemState createState() => _TimerListItemState();
}

class _TimerListItemState extends State<TimerListItem> {
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    duration = Duration(seconds: widget.timerModel.timeLeft);
    new Timer.periodic(Duration(seconds: 1), (timer) {
      if (widget.timerModel.status == 1) return;

      if (duration == Duration.zero || widget.timerModel.status == -1) {
        setState(() {
          widget.timerModel.setStatus(-1);
          DatabaseManager.instance.updateTimer(widget.timerModel);
        });
        timer.cancel();
        return;
      }
      setState(() {
        duration = Duration(seconds: duration.inSeconds - 1);
      });

      widget.timerModel.setTimeLeft(duration.inSeconds);
      DatabaseManager.instance.updateTimer(widget.timerModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TaskScreen(
                      timerModel: widget.timerModel,
                    )),
          );
        },
        child: Card(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.timerModel.title,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.timerModel.description,
                          maxLines: 3,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: size.width / 3,
                child: widget.timerModel.status != -1
                    ? Text(Utils.getFormattedDuration(duration))
                    : Text("Completed"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
