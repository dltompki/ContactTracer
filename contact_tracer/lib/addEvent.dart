import 'package:contact_tracer/event.dart';
import 'package:contact_tracer/homeList.dart';
import 'package:flutter/material.dart';

class AddEvent {
  static BuildContext context;
  Function callback;

  static String inputLocation;
  static String inputPerson;
  static String inputDate;

  AddEvent(BuildContext context, {Function callback}) {
    AddEvent.context = context;
    this.callback = callback;
  }

  Card location = Card(
    child: ListTile(
      leading: Icon(Icons.place),
      title: TextField(
        decoration: InputDecoration(labelText: 'Location'),
        onChanged: (String value) {
          inputLocation = value;
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
          inputPerson = value;
        },
      ),
    ),
  );

  Card date = Card(
    child: ListTile(
      leading: Icon(Icons.date_range),
      title: TextField(
        decoration: InputDecoration(labelText: 'Date'),
        onChanged: (String value) {
          inputDate = value;
        },
      ),
    ),
  );

  MaterialPageRoute getRoute() {
    return MaterialPageRoute(
      builder: (context) {
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
              date,
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.check),
            onPressed: _submitNewEvent,
          ),
        );
      },
    );
  }

  AlertDialog unfilledField = new AlertDialog(
    title: Text('Not All Text Fields Filled'),
    content: SingleChildScrollView(
      child:
          Text('Please fill out the location, person, and date of you event.'),
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

  void _submitNewEvent() {
    if ((inputLocation != null) &&
        (inputPerson != null) &&
        (inputDate != null)) {
      Event e = new Event(inputLocation, inputPerson, inputDate);
      callback(e);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context, 
        barrierDismissible: false, 
        useRootNavigator: false,
        builder: (context) {
          return unfilledField;
          },
      );
    }
  }
}
