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
  Coordinates _inputLocation;
  String _inputLocationName;
  String _inputPerson;
  DateTime _inputDate;
  TimeOfDay _inputTime;

  AddDateAndTime dateAndTime;
  AddLocation location;

  _AddEventState() {
    dateAndTime = new AddDateAndTime(updateInputDateAndTime);
    location = new AddLocation(updateInputLocation);
  }

  void updateInputDateAndTime({DateTime inputDate, TimeOfDay inputTime}) {
    if (inputTime != null) {
      _inputTime = inputTime;
    }

    if (inputDate != null) {
      _inputDate = inputDate;
    }
  }

  void updateInputLocation(Coordinates location, String locationName) {
    _inputLocation = location;
    _inputLocationName = locationName;
  }

  @override
  Widget build(BuildContext _context) {
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

    void _submitNewEvent() {
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
