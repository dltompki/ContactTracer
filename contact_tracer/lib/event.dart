import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'utility.dart';
import 'addEvent.dart';

class Event {
  List<String> people;
  final String formattedPeople;
  final DateTime date;
  final TimeOfDay time;
  final Coordinates location;
  final String locationName;

  Utility util = Utility();

  /// Default contruction for when event is created by the user
  Event(Coordinates location, String locationName, String formattedPeople, DateTime date, TimeOfDay time)
      : this.location = location,
        this.formattedPeople = formattedPeople,
        this.date = date,
        this.time = time,
        this.locationName = locationName {
          people = formattedPeople.split(AddEvent.personDelimiter);
          for (var i = 0; i < people.length; i++) {
            people[i] = people[i].trim();
          }
        }

  /// Parsing constructor for importing from the database accoring to the format established by [toMap]
  // Event.parse(Map<String, dynamic> map)
  //     : this.location = map['location'],
  //       this.people = map['person'], /// TODO this isn't right
  //       this.date = DateTime.parse(map['date']),
  //       this.time = TimeOfDay(
  //           hour: int.parse(map['hour']), minute: int.parse(map['minute'])),
  //       this.locationName = map['locationName'];

  String get formatDate => Utility.formatDate(date);
  String get formatTime => Utility.formatTime(time);

  /// Export this [Event] as a [Map<String, dynamic>] to enter it into the database
  List<Map<String, dynamic>> toMaps() {
    int id = DateTime.now().microsecondsSinceEpoch;
    List<Map<String, dynamic>> output = [];
    people.forEach((person) {
      output.add({
        'id' : id,
        'latitude': location.latitude,
        'longitude' : location.longitude,
        'locationName' : locationName,
        'people': formattedPeople,
        'person' : person,
        'date': date.toIso8601String(),
        'hour': time.hour,
        'minute': time.minute,
      });
    });
  }
}
