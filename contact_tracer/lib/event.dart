import 'package:flutter/material.dart';
import 'utility.dart';

class Event {
  final String location, person;
  final DateTime date;
  final TimeOfDay time;

  Utility util = Utility();

  Event(String location, String person, DateTime date, TimeOfDay time)
      : this.location = location,
        this.person = person,
        this.date = date,
        this.time = time;

  Event.parse(Map<String, dynamic> map)
      : this.location = map['location'],
        this.person = map['person'],
        this.date = DateTime.parse(map['date']),
        this.time = TimeOfDay(
            hour: int.parse(map['hour']), minute: int.parse(map['minute']));

  String get formatDate => util.formatDate(date);
  String get formatTime => util.formatTime(time);

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'person': person,
      'date': date.toIso8601String(),
      'hour': '${time.hour}',
      'minute': '${time.minute}',
    };
  }
}
