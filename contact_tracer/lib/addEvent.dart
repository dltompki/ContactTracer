import 'package:contact_tracer/contactTracer.dart';
import 'package:contact_tracer/event.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'addDateAndTime.dart';
import 'dart:collection';
import 'utility.dart';
import 'addLocation.dart';

class AddEvent extends StatefulWidget {
  // Delimiter between multiple people
  static final personDelimiter = ',';

  final List<String> people; // current list of people in the database
  final Function
      addEventToDatabase; // callback function excuted when event is submitted by user

  AddEvent({final List<String> people, final Function addEventToDatabase})
      : this.people = people,
        this.addEventToDatabase = addEventToDatabase;

  @override
  _AddEventState createState() => _AddEventState(people);
}

class _SelectedPeople {
  String persons;
  bool selected;

  _SelectedPeople(final persons, final selected)
      : this.persons = persons,
        this.selected = selected;
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
  // Use a SplayTreeMap so that people (the key) are automatically sorted alphabetically
  var _selectedPeople = new SplayTreeMap<String, _SelectedPeople>(
      (a, b) => _sortSelectedPeople(a, b));

  // Text that displays the currently selected people as a comma separted list
  var _displaySelectedPeopleText = '';

  // The result of the input person dialog
  var _inputPersons;

  // Constructor
  /// Initializes the [AddDateAndTime] widget and the [AddLocation] widget
  _AddEventState(final people) {
    // Initialize list of selected people to the list currently in the
    // database and don't select any of them, since this is a new event
    _configureSelectedPeople(people, false);
    dateAndTime = new AddDateAndTime(updateInputDateAndTime);
    location = new AddLocation(updateInputLocation);
  }

  // Validates inputted location
  bool _validateInputLocation() {
    if (_inputLocation == null) return false;

    return true;
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

  // Validates inputted date and time
  bool _validateInputDateAndTime() {
    if (_inputTime == null) return false;
    if (_inputDate == null) return false;

    return true;
  }

  // Prevent duplicate entries in the selected people list where
  // the only difference between them is capitalization
  String _normalizeSelectedPeopleKey(final key) {
    return key.toLowerCase().trim();
  }

  // Retrieve the requested selected people entry
  _SelectedPeople _getSelectedPeopleEntry(final persons) {
    return _selectedPeople[_normalizeSelectedPeopleKey(persons)];
  }

  // Configure the specified selected people entry
  void _setSelectedPeopleEntry(final persons, final selected) {
    final key = _normalizeSelectedPeopleKey(persons);

    // If an entry already exists, only change its selected state
    if (_selectedPeople.containsKey(key)) {
      _selectedPeople[key].selected = selected;
    } else {
      _selectedPeople[key] = _SelectedPeople(persons, selected);
    }
  }

  void _updateSelectedPeopleEntrySelectedState(final entry, final selected) {
    // We must use the update() method when iterating, which
    // means we must make a copy of the existing entry in
    // order to modify it
    var updatedEntry = entry;
    updatedEntry.selected = selected;
    _selectedPeople.update(
        _normalizeSelectedPeopleKey(entry.persons), (value) => updatedEntry);
  }

  // Indicates if any people have been selected
  bool _peopleSelected() {
    for (var e in _selectedPeople.values) {
      if (e.selected) {
        return true;
      }
    }

    return false;
  }

  // Sorts the selected people, first based on the number of people
  // in the entry and then alphabetically
  static int _sortSelectedPeople(final a, final b) {
    var aListSize = a.split(AddEvent.personDelimiter).length;
    var bListSize = b.split(AddEvent.personDelimiter).length;
    // if (aListSize != bListSize) return aListSize.compareTo(bListSize);
    if (aListSize != bListSize) return (bListSize - aListSize);

    return a.compareTo(b);
  }

  // Configures the selected persons text field
  void _configureSelectedPersonsText(final selected) {
    // Build comma separated list
    _displaySelectedPeopleText = '';
    for (var e in _selectedPeople.values) {
      // Only add the persons if they are selected (checked)
      if (e.selected) {
        // Add people one at a time to avoid duplicates
        e.persons.split(AddEvent.personDelimiter).forEach((name) {
          // Only add if not already in the list
          if (!_displaySelectedPeopleText
              .toLowerCase()
              .contains(name.toLowerCase())) {
            _displaySelectedPeopleText = Utility.appendToDelimitedString(
                _displaySelectedPeopleText, name, AddEvent.personDelimiter);
          }
        });
      }
    }

    // If no people are selected, configure a default label
    if (_displaySelectedPeopleText.length == 0) {
      _displaySelectedPeopleText = 'Person(s)';
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
        var personList = persons.split(AddEvent.personDelimiter);
        for (var i = 0; i < personList.length; ++i) {
          personList[i] = personList[i].trim();
          _setSelectedPeopleEntry(personList[i], selected);
        }

        // Rebuild the persons in alphabetical order so we don't
        // end up with the same group of people in different orders
        var alphabeticalPersons = persons;
        if (personList.length > 1) {
          // Compare entries in all lowercase to avoid impacts of different capitalization
          personList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

          alphabeticalPersons = '';
          personList.forEach((person) {
            alphabeticalPersons = Utility.appendToDelimitedString(
                alphabeticalPersons, person, AddEvent.personDelimiter);
          });
          _setSelectedPeopleEntry(alphabeticalPersons, selected);
        }

        // Synchronize entries
        if (selected) {
          synchronizeSelectedEntries();
        } else {
          synchronizeDeselectedEntries(alphabeticalPersons);
        }
      }
    });

    // Configure the selected persons text field
    _configureSelectedPersonsText(selected);
  }

  // Synchronize all entries to the currently configured selected set
  void synchronizeSelectedEntries() {
    // Obtain the keys of all the individual selected entries
    // - Use a set to avoid duplicates when processing groups
    var individualSelectedKeys = Set<String>();
    for (var selectedPeopleData in _selectedPeople.values) {
      if (selectedPeopleData.selected) {
        selectedPeopleData.persons.split(AddEvent.personDelimiter).forEach((person) {
          individualSelectedKeys.add(_normalizeSelectedPeopleKey(person));
        });
      }
    }

    // Iterate over all entries, selecting those whose persons are
    // entirely within the selected set
    for (var currentEntry in _selectedPeople.values) {
      var update = true;
      for (final person in currentEntry.persons.split(AddEvent.personDelimiter)) {
        if (!individualSelectedKeys
            .contains(_normalizeSelectedPeopleKey(person))) {
          update = false;
          break;
        }
      }

      if (update) {
        _updateSelectedPeopleEntrySelectedState(currentEntry, true);
      }
    }
  }

  // Synchronize all entries to the currently configured selected set
  void synchronizeDeselectedEntries(final deselectedPersons) {
    final normalizedDeselectedPersons =
        _normalizeSelectedPeopleKey(deselectedPersons);

    // Iterate over all entries, deselecting those that contain any
    // person in the deselected key
    for (var currentEntry in _selectedPeople.values) {
      var update = false;
      for (final person in currentEntry.persons.split(AddEvent.personDelimiter)) {
        if (normalizedDeselectedPersons
            .contains(_normalizeSelectedPeopleKey(person))) {
          update = true;
          break;
        }
      }

      if (update) {
        _updateSelectedPeopleEntrySelectedState(currentEntry, false);
      }
    }
  }

  // Simply return to the previous dialog
  void _inputPersonDialogDismiss([final result]) {
    Navigator.of(context).pop(result);
  }

  // Return the name of the inputted person to the previous dialog
  void _inputPersonDialogAccept() {
    _inputPersonDialogDismiss(_inputPersons);
  }

  // Alows the user to input a new person
  Future<String> _inputPersonDialog(BuildContext context) async {
    _inputPersons = '';

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
                onSubmitted: (persons) {
                  // No need to consume name since it is processed in onChanged
                  _inputPersonDialogAccept();
                },
                onChanged: (persons) {
                  _inputPersons = persons;
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
    widget.addEventToDatabase(Event(_inputLocation, _inputLocationName,
        _displaySelectedPeopleText, _inputDate, _inputTime));

    // Return to the previous screen
    Navigator.pop(context);
  }

  // Creates the persons card
  Card _createPersonsCard() {
    return Card(
      child: Column(
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
                  final persons = await _inputPersonDialog(context);
                  if (persons != null) {
                    _configureSelectedPeople(List.filled(1, persons), true);
                    setState(() {});
                  }
                },
              ),
            ],
          ),
          // Subsequent rows are a list of people from which those that
          // participate in the event can be selected
          new Column(
              children: _selectedPeople.keys.map((String name) {
            return new CheckboxListTile(
              title: new Text(_getSelectedPeopleEntry(name).persons),
              value: _getSelectedPeopleEntry(name).selected,
              onChanged: (bool checked) {
                setState(() {
                  // Update the checkbox state and selected persons display
                  _configureSelectedPeople(
                      List.filled(1, _getSelectedPeopleEntry(name).persons),
                      checked);
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
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: RaisedButton(
              onPressed: _addEvent,
              color: accentColor,
              child: Icon(
                Icons.check,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          location,
          dateAndTime,
          _createPersonsCard(),
        ],
      ),
    );
  }
}
