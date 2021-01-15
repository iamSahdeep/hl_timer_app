class TimerModel {
  final int id;
  final String title;
  final String description;
  final int timeLeft;
  final int status;

  TimerModel(
      {this.id, this.title, this.description, this.timeLeft, this.status});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timeLeft': timeLeft,
      'status': status
    };
  }

  TimerModel.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        timeLeft = map['timeLeft'],
        status = map['status'];
}
