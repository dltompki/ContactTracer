import 'package:contact_tracer/event.dart';
import 'package:flutter/material.dart';

class AddEvent {
  static BuildContext context;
  Function callback;

  static String inputLocation;
  static String inputPerson;

  static TimeOfDay _selectedTime;
  static DateTime _selectedDate;

  static String inputTime;
  static String inputDate;

  // static TimeOfDay _selectedTime = TimeOfDay.now();
  // static DateTime _selectedDate = DateTime.now();

  // static String inputDate = _selectedDate.toUtc.toString();
  // static String inputTime = _selectedTime.toString();

  AddEvent(BuildContext incomingContext, {Function callback}) {
    context = incomingContext;
    this.callback = callback;
  }

  MaterialPageRoute getRoute() {
    _selectedTime = TimeOfDay.now();
    _selectedDate = DateTime.now();

    inputDate = _selectedDate.toUtc.toString();
    inputTime = _selectedTime.toString();

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
        title: Column(
          children: [
            Row(children: [
              Text('Date: '),
              RaisedButton(
                child: Text(_selectedDate.toString()),
                onPressed: () {
                  pickDateAndStore();
                },
              ),
            ]),
            Row(children: [
              Text('Time: '),
              RaisedButton(
                child: Text(_selectedTime.format(context)),
                onPressed: () {
                  pickTimeAndStore();
                },
              ),
            ]),
          ],
        ),
      ),
    );

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

  static void pickDateAndStore() async {
    _selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    inputDate = _selectedDate.toUtc().toString();
  }

  static void pickTimeAndStore() async {
    _selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    inputTime = _selectedTime.toString();
  }

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

    if ((inputLocation != null) &&
        (inputPerson != null) &&
        (inputDate != null) &&
        (inputTime != null)) {
      Event e = new Event(inputLocation, inputPerson, inputDate, inputTime);
      callback(e);
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
}
