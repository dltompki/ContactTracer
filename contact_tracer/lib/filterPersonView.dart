import 'package:flutter/material.dart';
import 'eventDatabase.dart';
import 'utility.dart';
import 'homeList.dart';
import 'event.dart';
import 'mapView.dart';

class FilterPersonView extends StatefulWidget {
  @override
  _FilterPersonViewState createState() => _FilterPersonViewState();
}

class _FilterPersonViewState extends State<FilterPersonView> {
  List<String> _selectedPeople = [];

  EventDatabase db = new EventDatabase();
  List<String> allPeople;

  Map<String, bool> people = {};

  HomeList homeList = new HomeList();

  bool isExpanded = true;

  void _deriveCheckboxMap() {
    allPeople.forEach((person) {
      people.addEntries([MapEntry(person, false)]);
    });
  }

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
                // Card(
                //   child: Container(
                //     child: FutureBuilder(
                //     future: db.getEventsByPeople(_deriveSelectedPeople()),
                //     builder: (BuildContext context,
                //         AsyncSnapshot<List<Event>> eventListData) {
                //       if (eventListData.hasData) {
                //         return Column(
                //           children:
                //               Utility.buildRows(context, eventListData.data),
                //         );
                //       } else {
                //         return Text('test');
                //       }
                //     },
                //   ),
                //   ), 
                // ),
                Card(
                  child: FutureBuilder(
                    future: db.getEventsByPeople(_deriveSelectedPeople()),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                      return Column(
                        children: Utility.buildRows(context, snapshot.data),
                      ); }
                      else {
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
