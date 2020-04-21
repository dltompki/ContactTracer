import 'package:contact_tracer/event.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'addDateAndTime.dart';
import 'addLocation.dart';

class AddEvent extends StatefulWidget {
  final Function addEventToList;

  AddEvent(Function addEventToList) : this.addEventToList = addEventToList;

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  /// This group of variables are what the [Event] that is being sent back to [HomeList] are constructed with
  Coordinates _inputLocation;
  String _inputLocationName;
  String _inputPerson;
  DateTime _inputDate;
  TimeOfDay _inputTime;

  AddDateAndTime dateAndTime;
  AddLocation location;

  /// Initializes the [AddDateAndTime] widget and the [AddLocation] widget
  _AddEventState() {
    dateAndTime = new AddDateAndTime(updateInputDateAndTime);
    location = new AddLocation(updateInputLocation);
  }

  /// Callback function passed to [AddDateAndTime] that allows any combination of [inputDate] and [inputTime] to be updated in the [AddEvent] widget
  void updateInputDateAndTime({DateTime inputDate, TimeOfDay inputTime}) {
    if (inputTime != null) {
      _inputTime = inputTime;
    }

    if (inputDate != null) {
      _inputDate = inputDate;
    }
  }

  /// Callback function passed to [AddLocation] that allows the [location] and [locationName] to be updated
  void updateInputLocation(Coordinates location, String locationName) {
    _inputLocation = location;
    _inputLocationName = locationName;
  }

  @override
  Widget build(BuildContext _context) {
    /// Allows user to enter a string for the [inputPerson] parameter of the [Event]
    Card person = Card(
      child: ListTile(
        leading: Icon(Icons.person),
        title: TextField(
          decoration: InputDecoration(labelText: 'Person'),
          onChanged: (String value) {
            _inputPerson = value;
          },
        ),
      ),
    );

    /// Called when the user indicates they are finished filling out the [AddEvent] form by clicking the [FloatingActionButton]
    void _submitNewEvent() {
      /// Pops up when the user attempts to submit but they haven't filled out all the properties
      AlertDialog unfilledField = new AlertDialog(
        title: Text('Not All Text Fields Filled'),
        content: SingleChildScrollView(
          child: Text(
              'Please fill out the location, person, and date of you event.'),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );

      /// Uses the callback function [addEventToList] if all the properites have been filled out. Otherwise, pops up [unfilledField]
      if ((_inputLocation != null) &&
          (_inputPerson != null) &&
          (_inputDate != null) &&
          (_inputTime != null)) {
        Event e = new Event(_inputLocation, _inputLocationName, _inputPerson,
            _inputDate, _inputTime);
        widget.addEventToList(e);
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          barrierDismissible: false, // force the user to have to press okay
          useRootNavigator: false,
          builder: (context) {
            return unfilledField;
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          location,
          person,
          dateAndTime,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: _submitNewEvent,
      ),
    );
  }
}
