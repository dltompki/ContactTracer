import 'package:contact_tracer/event.dart';
import 'package:flutter/material.dart';
import 'addDateAndTime.dart';

class AddEvent extends StatefulWidget {
  Function addEventToList;

  AddEvent(Function addEventToList) {
    this.addEventToList = addEventToList;
  }

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  static String _inputLocation;
  static String _inputPerson;
  static DateTime _inputDate;
  static TimeOfDay _inputTime;

  static void updateInputDateAndTime({DateTime inputDate, TimeOfDay inputTime}) {
    if (inputTime != null) {
      _inputTime = inputTime;
    }

    if (inputDate != null) {
      _inputDate = inputDate;
    }
  }

  AddDateAndTime dateAndTime = new AddDateAndTime(updateInputDateAndTime);

  @override
  Widget build(BuildContext _context) {
    Card location = Card(
      child: ListTile(
        leading: Icon(Icons.place),
        title: TextField(
          decoration: InputDecoration(labelText: 'Location'),
          onChanged: (String value) {
            _inputLocation = value;
          },
        ),
      ),
    );

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
        Event e =
            new Event(_inputLocation, _inputPerson, _inputDate, _inputTime);
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
