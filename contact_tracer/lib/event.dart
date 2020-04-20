import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'utility.dart';

class Event {
  final String person;
  final DateTime date;
  final TimeOfDay time;
  final Coordinates location;
  final String locationName;

  Utility util = Utility();

  /// Default contruction for when event is created by the user
  Event(Coordinates location, String locationName, String person, DateTime date, TimeOfDay time)
      : this.location = location,
        this.person = person,
        this.date = date,
        this.time = time,
        this.locationName = locationName;

  /// Parsing constructor for importing from the database accoring to the format established by [toMap]
  Event.parse(Map<String, dynamic> map)
      : this.location = map['location'],
        this.person = map['person'],
        this.date = DateTime.parse(map['date']),
        this.time = TimeOfDay(
            hour: int.parse(map['hour']), minute: int.parse(map['minute'])),
        this.locationName = map['locationName'];

  String get formatDate => util.formatDate(date);
  String get formatTime => util.formatTime(time);

  /// Export this [Event] as a [Map<String, dynamic>] to enter it into the database
  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'locationName' : locationName,
      'person': person,
      //'people' : people,
      'date': date.toIso8601String(),
      'hour': '${time.hour}',
      'minute': '${time.minute}',
    };
  }
}
