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
  // Delimiter between multiple people
  static final _personDelimiter = ',';

  // Configured values
  var _inputLocation;
  var _inputDate;
  var _inputTime;

  // Use a SplayTreeMap so that people (the key) are automatically sorted alphabetically

  var _selectedPeople =
      new SplayTreeMap<String, bool>((a, b) => _sortSelectedPeople(a, b));

  // Text that displays the currently selected people as a comma separted list
  var _displaySelectedPeopleText = '';

  // The result of the input person dialog
  var _inputPerson;

  // Constructor
  _AddEventState(final people) {
    // Initialize list of selected people to the list currently in the
    // database and don't select any of them, since this is a new event
    _configureSelectedPeople(people, false);
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

  // Prevent duplicate entries in the selected people list where
  // the only difference between them is capitalization
  String _normalizeSelectedPeopleKey(final key) {
    return key.toLowerCase();
  }

  // Retrieve the requested selected people entry
  bool _getSelectedPeopleEntry(final persons) {
    return _selectedPeople[_normalizeSelectedPeopleKey(persons)];
  }

  // Configure the specified selected people entry
  void _setSelectedPeopleEntry(final persons, final checked) {
    _selectedPeople[_normalizeSelectedPeopleKey(persons)] = checked;
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

  // Sorts the selected people, first based on the number of people
  // in the entry and then alphabetically
  static int _sortSelectedPeople(final a, final b) {
    var aListSize = a.split(_personDelimiter).length;
    var bListSize = b.split(_personDelimiter).length;
    if (aListSize != bListSize) return aListSize.compareTo(bListSize);

    return a.compareTo(b);
  }

  // Configures the selected persons text field
  void _configureSelectedPersonsText() {
    // Build comma separated list
    _displaySelectedPeopleText = '';
    _selectedPeople.forEach((persons, checked) {
      // Only add the persons if they are selected (checked)
      if (checked) {
        // Add people one at a time to avoid duplicates
        persons.split(_personDelimiter).forEach((name) {
          // Only add if not already in the list
          if (!_displaySelectedPeopleText.contains(name)) {
            _displaySelectedPeopleText = Utility.appendToDelimitedString(
                _displaySelectedPeopleText, name, _personDelimiter);
          }
        });
      }
    });

    // If no people are selected, configure a default label
    if (_displaySelectedPeopleText.length == 0) {
      _displaySelectedPeopleText = 'Person(s)';
    }
    // Otherwise, synchronize the matching group entry, if it exists
    else if (_selectedPeople
        .containsKey(_normalizeSelectedPeopleKey(_displaySelectedPeopleText))) {
      _setSelectedPeopleEntry(_displaySelectedPeopleText, true);
    }
  }

  // Adds persons to the list of people and updates the selected persons display
  void _configureSelectedPeople(
      final List<String> listOfPersons, final selected) {
    // Add/update each selected persons checkbox
    listOfPersons.forEach((persons) {
      // Handle whitespace only strings
      persons = persons.trim();
      if (persons.length > 0) {
        // If persons is a group of people, add each person individually
        var personList = persons.split(_personDelimiter);
        for (var i = 0; i < personList.length; ++i) {
          personList[i] = personList[i].trim();
          _setSelectedPeopleEntry(personList[i], selected);
        }

        // Rebuild the persons in alphabetical order so we don't
        // end up with the same group of people in different orders
        var alphabeticalPersons = persons;
        if (personList.length > 1) {
          personList.sort();

          alphabeticalPersons = '';
          personList.forEach((person) {
            alphabeticalPersons = Utility.appendToDelimitedString(
                alphabeticalPersons, person, _personDelimiter);
          });
          _setSelectedPeopleEntry(alphabeticalPersons, selected);
        }

        // Synchronize entries
        for (var selectedPersons in _selectedPeople.keys) {
          if (selected
              ? (alphabeticalPersons.contains(selectedPersons))
              : (selectedPersons.contains(alphabeticalPersons))) {
            _selectedPeople.update(_normalizeSelectedPeopleKey(selectedPersons),
                (value) => selected);
          }
        }
      }
    });

    // Configure the selected persons text field
    _configureSelectedPersonsText();
  }

  void _inputPersonDialogDismiss([final result]) {
    Navigator.of(context).pop(result);
  }

  // Return the name of the inputted person to the previous widget
  void _inputPersonDialogAccept() {
    _inputPersonDialogDismiss(_inputPerson);
  }

  // Alows the user to input a new person
  Future<String> _inputPersonDialog(BuildContext context) async {
    _inputPerson = '';

    return showDialog<String>(
      context: context,
      barrierDismissible: false, // Force the user to have to press a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter name'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(labelText: 'Person'),
                onSubmitted: (name) {
                  // No need to consume name since it is processed in onChanged
                  _inputPersonDialogAccept();
                },
                onChanged: (value) {
                  _inputPerson = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            Utility.createCancelButton(_inputPersonDialogDismiss),
            Utility.createOkButton(_inputPersonDialogAccept),
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
        barrierDismissible: false, // Force the user to have to press OK
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
                  final person = await _inputPersonDialog(context);
                  if (person != null) {
                    _configureSelectedPeople(List.filled(1, person), true);
                    setState(() {});
                  }
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
                  value: _getSelectedPeopleEntry(name),
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
