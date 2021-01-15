import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:hl_timer_app/CORE/DataModels/TimerModel.dart';
import 'package:hl_timer_app/CORE/Database/DatabaseManager.dart';
import 'package:hl_timer_app/CORE/Helpers/Utils.dart';
import 'package:hl_timer_app/CORE/Notifiers/TimersNotifier.dart';

class AddTimerScreen extends StatefulWidget {
  final TimersNotifier notifier;

  const AddTimerScreen({Key key, this.notifier}) : super(key: key);

  @override
  _AddTimerScreenState createState() => _AddTimerScreenState();
}

class _AddTimerScreenState extends State<AddTimerScreen> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  Duration duration = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Timer"),
      ),
      body: Builder(builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: TextField(
                    controller: titleController,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    decoration: InputDecoration(
                      labelText: "Title",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: TextField(
                    controller: descriptionController,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),
              Center(
                child: RaisedButton(
                    child:
                        Text("Timer : ${Utils.getFormattedDuration(duration)}"),
                    onPressed: () {
                      _onTimePicker(context);
                    }),
              ),
              Center(
                child: RaisedButton(
                    child: Text("Confirm"),
                    onPressed: () {
                      if (duration == Duration.zero ||
                          titleController.text.isEmpty ||
                          descriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: new Text('Please check values'),
                          duration: Duration(seconds: 1),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: new Text('Adding Timer'),
                          duration: Duration(seconds: 1),
                        ));

                        DatabaseManager.instance
                            .insertTimer(new TimerModel(
                                id: null,
                                title: titleController.text,
                                description: descriptionController.text,
                                timeLeft: duration.inSeconds,
                                status: 0))
                            .whenComplete(() async {
                          await widget.notifier.getTimersFromDatabase();
                          Navigator.of(context).pop();
                        });
                      }
                    }),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _onTimePicker(BuildContext context) {
    Picker(
      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
        const NumberPickerColumn(begin: 0, end: 999, suffix: Text(' H')),
        const NumberPickerColumn(begin: 00, end: 59, suffix: Text(' M')),
        const NumberPickerColumn(begin: 00, end: 59, suffix: Text(' S')),
      ]),
      hideHeader: true,
      confirmText: 'OK',
      title: const Text('Select Timer'),
      onConfirm: (Picker picker, List<int> value) {
        // You get your duration here
        setState(() {
          duration = Duration(
              hours: picker.getSelectedValues()[0],
              minutes: picker.getSelectedValues()[1],
              seconds: picker.getSelectedValues()[2]);
        });
      },
    ).showDialog(context);
  }
}
