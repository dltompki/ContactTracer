import 'package:flutter/material.dart';
import 'eventDatabase.dart';
import 'utility.dart';
import 'mapView.dart';
import 'event.dart';

class FilterPersonView extends StatefulWidget {
  @override
  _FilterPersonViewState createState() => _FilterPersonViewState();
}

class _FilterPersonViewState extends State<FilterPersonView> {
  /// What the list of events is generated based upon
  List<String> _selectedPeople = [];

  EventDatabase db = new EventDatabase();

  /// All of the indivduals in the database
  List<String> allPeople;

  /// Map of [allPeople], used to manage checkboxes state
  Map<String, bool> people = {};

  /// Manages the state of the expansion panel
  bool isExpanded = true;

  /// populates [people] using [allPeople]. should only be run once or [people] will be reset
  void _deriveCheckboxMap() {
    allPeople.forEach((person) {
      people.addEntries([MapEntry(person, false)]);
    });
  }

  /// format for [CheckboxListTile]
  CheckboxListTile _checkboxFactory(String key, int id) {
    return CheckboxListTile(
      title: Text(key),
      value: people.values.elementAt(id),
      onChanged: (newValue) {
        setState(() {
          people.update(key, (value) => newValue);
        });
      },
    );
  }

  /// Builds checkboxes using [_checkboxFactory] based upon [people]
  List<CheckboxListTile> _buildCheckboxes() {
    if (people.length == 0) {
      _deriveCheckboxMap();
    }

    List<CheckboxListTile> _output = [];

    for (var i = 0; i < people.length; i++) {
      _output.add(_checkboxFactory(people.keys.elementAt(i), i));
    }

    return _output;
  }

  /// returns all of the keys in [people] whose value is true
  List<String> _deriveSelectedPeople() {
    List<String> output = [];

    if (people.length == 0) {
      _deriveCheckboxMap();
    }

    people.forEach((key, value) {
      if (value == true) {
        output.add(key);
      }
    });

    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Filter By Person'),
      ),
      body: FutureBuilder(
        future: db.getAllPeople(),

        /// returns all individuals in [EventDatabase]
        builder:
            (BuildContext context, AsyncSnapshot<List<String>> allPeopleData) {
          if (allPeopleData.hasData) {
            allPeople = allPeopleData.data;

            return ListView(
              children: [
                Card(
                  child: ExpansionPanelList(
                    expansionCallback: (id, state) {
                      setState(() {
                        isExpanded = !state;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          if (_selectedPeople.length > 0) {
                            String _displaySelectedPeople;
                            for (var i = 0; i < _selectedPeople.length; i++) {
                              if (i == 0) {
                                _displaySelectedPeople = _selectedPeople[0];
                              } else {
                                Utility.appendToDelimitedString(
                                    _displaySelectedPeople,
                                    _selectedPeople[i],
                                    ',');
                              }
                            }
                            return Container(
                              padding: EdgeInsets.only(left: 10, top: 15),
                              child: Text(_displaySelectedPeople),
                            );
                          } else {
                            return Container(
                              padding: EdgeInsets.only(left: 10, top: 15),
                              child: Text('Select Person(s)'),
                            );
                          }
                        },
                        body: Column(
                          children: _buildCheckboxes(),
                        ),
                        canTapOnHeader: true,
                        isExpanded: isExpanded,
                      ),
                    ],
                  ),
                ),
                Card(
                  child: FutureBuilder(
                    future: db.getEventsByPeople(_deriveSelectedPeople()),

                    /// returns a [List<Event>] based upon the currently selected people
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Event>> events) {
                      if (events.hasData) {
                        return Column(
                          children: Utility.buildRows(context, events.data),
                        );
                      } else {
                        return Loading();
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: Loading(),
            );
          }
        },
      ),
    );
  }
}
