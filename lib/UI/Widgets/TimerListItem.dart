import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hl_timer_app/CORE/DataModels/TimerModel.dart';

class TimerListItem extends StatefulWidget {
  final TimerModel timerModel;

  const TimerListItem({Key key, this.timerModel}) : super(key: key);

  @override
  _TimerListItemState createState() => _TimerListItemState();
}

class _TimerListItemState extends State<TimerListItem> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(widget.timerModel.title),
                Text(widget.timerModel.description)
              ],
            ),
          ),
          SizedBox(
            width: size.width / 3,
            child: widget.timerModel.status == 0
                ? Text("time")
                : Text("Completed"),
          )
        ],
      ),
    );
  }
}
