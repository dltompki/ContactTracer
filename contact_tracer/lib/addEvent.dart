import 'package:contact_tracer/event.dart';
import 'package:flutter/material.dart';
import 'addDateAndTime.dart';
import 'dart:collection';
import 'utility.dart';

class AddEvent extends StatefulWidget {
  final List<String> people; // current list of people in the database
  final Function
      addEventToList; // callback function excuted when event is submitted by user

  AddEvent(final people, final Function addEventToList)
      : this.people = people,
        this.addEventToList = addEventToList;

  @override
  _AddEventState createState() => _AddEventState(people);
}

class _AddEventState extends State<AddEvent> {
  // Configured values
  var _inputLocation;
  var _inputDate;
  var _inputTime;

  // Use a SplayTreeMap so that people (the key) are automatically sorted alphabetically
  var _selectedPeople = new SplayTreeMap<String, bool>();

  // Text that displays the currently selected people as a comma separted list
  var _displaySelectedPeopleText = '';

  // Constructor
  _AddEventState(final people) {
    // Initialize list of selected people to the list currently in the
    // database and don't select any of them, since this is a new event
    _configureSelectedPeople(people, false);
  }

  // Creates the location card
  Card _createLocationCard() {
    return Card(
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
  }

  // Validates inputted location
  bool _validateInputLocation() {
    if (_inputLocation == null) return false;

    return true;
  }

  // Configures inputted date and time
  void _updateInputDateAndTime({final inputDate, final inputTime}) {
    if (inputTime != null) {
      _inputTime = inputTime;
    }

    if (inputDate != null) {
      _inputDate = inputDate;
    }
  }

  // Validates inputted date and time
  bool _validateInputDateAndTime() {
    if (_inputTime == null) return false;
    if (_inputDate == null) return false;

    return true;
  }

  // Creates the persons card
  Card _createPersonsCard() {
    return Card(
      child: Column(
        // Configure widgets to consume minimum amount of vertical space
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // First row contains the list of currently selected persons
          // and a button to add a new person
          Row(
            children: <Widget>[
              // Displays list of currently selected persons
              Expanded(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(_displaySelectedPeopleText),
                ),
              ),
              // Button to add a new person
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                tooltip: 'Add person',
                onPressed: () async {
                  // Add the person to the list of selected people and
                  // automatically select them
                  _configureSelectedPeople(
                      List.filled(1, await _inputPerson(context)), true);
                  setState(() {});
                },
              ),
            ],
          ),
          // Subsequent rows are a list of people from which those that
          // participate in the event can be selected
          new ListView(
              shrinkWrap: true,
              children: _selectedPeople.keys.map((String name) {
                return new CheckboxListTile(
                  title: new Text(name),
                  value: _selectedPeople[name],
                  onChanged: (bool checked) {
                    setState(() {
                      // Update the checkbox state and selected persons display
                      _configureSelectedPeople(List.filled(1, name), checked);
                    });
                  },
                );
              }).toList()),
        ],
      ),
    );
  }

  // Adds persons to the list of people and updates the selected persons display
  void _configureSelectedPeople(
      final List<String> listOfPersons, final selected) {
    if (listOfPersons.length == 0) return;

    // Add/update each selected persons checkbox
    listOfPersons.forEach((persons) {
      if (persons.length > 0) {
        _selectedPeople[persons] = selected;
      }
    });

    // Configure the selected persons text field
    _configureSelectedPersonsText();
  }

  // Indicates if any people have been selected
  bool _peopleSelected() {
    for (var checked in _selectedPeople.values) {
      if (checked) {
        return true;
      }
    }

    return false;
  }

  // Configures the selected persons text field
  void _configureSelectedPersonsText() {
    // Build comma separated list
    _displaySelectedPeopleText = '';
    _selectedPeople.forEach((name, checked) {
      if (checked) {
        _displaySelectedPeopleText +=
            ((_displaySelectedPeopleText.length > 0) ? ', ' : '') + name;
      }
    });

    // If no people are selected, configure a default label
    if (_displaySelectedPeopleText.length == 0) {
      _displaySelectedPeopleText = 'Person(s)';
    }
  }

  // Alows the user to input a new person
  Future<String> _inputPerson(BuildContext context) async {
    String name = '';

    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter name'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(labelText: 'Person'),
                onChanged: (value) {
                  name = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop(name);
              },
            ),
          ],
        );
      },
    );
  }

  // Validates if the event is properly configured
  bool _eventIsValid() {
    if (!_validateInputLocation()) return false;
    if (!_validateInputDateAndTime()) return false;
    if (!_peopleSelected()) return false;

    return true;
  }

  // Adds the event to the database
  void _addEvent() {
    // If the event is not properly configured, inform the user and ignore their request to add it
    if (!_eventIsValid()) {
      showDialog(
        context: context,
        barrierDismissible: false, // force the user to have to press okay
        useRootNavigator: false,
        builder: (context) {
          // Default AlertDialog simply contains an OK button
          return AlertDialog(
            title: Text('Missing Information'),
            content: SingleChildScrollView(
              child: Text(
                  'Please enter the location, date/time and person(s) of your event.'),
            ),
            actions: [
              Utility.createOkButton(Navigator.of(context).pop),
            ],
          );
        },
      );

      return;
    }

    // Add the event to the database
    widget.addEventToList(Event(
        _inputLocation, _displaySelectedPeopleText, _inputDate, _inputTime));

    // Return to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
          _createLocationCard(),
          AddDateAndTime(_updateInputDateAndTime),
          _createPersonsCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: _addEvent,
      ),
    );
  }
}
