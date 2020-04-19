import 'package:contact_tracer/event.dart';
import 'package:flutter/material.dart';
import 'addDateAndTime.dart';
import 'dart:collection';

class AddEvent extends StatefulWidget {
  final Function addEventToList;

  AddEvent(Function addEventToList) : this.addEventToList = addEventToList;

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  String _inputLocation;
  DateTime _inputDate;
  TimeOfDay _inputTime;

  // Use a SplayTreeMap so that items are sorted by key
  SplayTreeMap<String, bool> _people = new SplayTreeMap<String, bool>();
  static final String _defaultDisplayPersons = 'Person(s)';
  String _displayPersons = _defaultDisplayPersons;

  AddDateAndTime dateAndTime;

  _AddEventState() {
    dateAndTime = new AddDateAndTime(_updateInputDateAndTime);

    // Default list for testing
    _people['Mike'] = true;
    _people['Dylan'] = false;

    // Configure the default people lable
    _setDisplayPersons();
  }

  void _updateInputDateAndTime({DateTime inputDate, TimeOfDay inputTime}) {
    if (inputTime != null) {
      _inputTime = inputTime;
    }

    if (inputDate != null) {
      _inputDate = inputDate;
    }
  }

  void _setDisplayPersons() {
    // Default to blank
    _displayPersons = '';

    // Build comma separated list
    _people.forEach((name, checked) {
      if (checked) {
        _displayPersons += ((_displayPersons.length > 0) ? ', ' : '') + name;
      }
    });

    // If no people are selected, use the default label
    if (_displayPersons.length == 0) {
      _displayPersons = _defaultDisplayPersons;
    }
  }

  bool _peopleExist() {
    for (var checked in _people.values) {
      if (checked) {
        return true;
      }
    }

    return false;
  }

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(_displayPersons),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {},
              ),
            ],
          ),
          new ListView(
              shrinkWrap: true,
              children: _people.keys.map((String name) {
                return new CheckboxListTile(
                  title: new Text(name),
                  value: _people[name],
                  onChanged: (bool checked) {
                    setState(() {
                      _people[name] = checked;
                      _setDisplayPersons();
                    });
                  },
                );
              }).toList()),
        ],
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
          _peopleExist() &&
          (_inputDate != null) &&
          (_inputTime != null)) {
        
        _people.forEach((name, checked) {
          if (checked) {
            Event e = new Event(_inputLocation, name, _inputDate, _inputTime);
            widget.addEventToList(e);
          }
        });
        
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
          dateAndTime,
          person,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: _submitNewEvent,
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
