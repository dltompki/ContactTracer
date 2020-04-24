import 'package:contact_tracer/utility.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'event.dart';
import 'details.dart';
import 'addEvent.dart';
import 'contactTracer.dart';
import 'eventDatabase.dart';

class HomeList extends StatefulWidget {
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  EventDatabase db = new EventDatabase();

  List<String> _getPeople(List<Event> eventList) {
    var people = List<String>();
    eventList.forEach((event) {
      people.add(event.formattedPeople);
    });
    return people;
  }

  @override
  Widget build(BuildContext context) {
    /// Opens the [Details] screen for the [Event] that was clicked on
    void _pushDetails(Event e) {
      Navigator.of(context).push(new Details(
        context,
        event: e,
      ).getRoute());
    }

    /// Callback function passed to the [AddEvent] screen to enable it to send events back to the [eventList]
    void addEventToDatabase(Event e) {
      List<Map<String, dynamic>> maps = e.toMaps();
      maps.forEach((map) {
        db.insertEvent(map);
      });
      setState(() {});
    }

    /// Opens the [AddEvent] screen, passing the [addEventToList] function to enable [Event]s to be sent back to the [HomeList]
    void _pushAddEvent(List<Event> eventList) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return new AddEvent(
              people: _getPeople(eventList),
              addEventToDatabase: addEventToDatabase,
            );
          },
        ),
      );
    }

    /// Builds a single [ListTile] for the [Event] passed in according to consistent formatting for [HomeList]
    Widget _rowFactory(Event e) {
      return ListTile(
        leading: Icon(Icons.place, color: accentColor),
        title: Text(e.locationName),
        subtitle: Text(e.formattedPeople),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(e.formatDate),
            Text(e.formatTime),
          ],
        ),
        onTap: () => {_pushDetails(e)},
      );
    }

    /// Calls [_rowFactory] for every [Event] in the [List<Event>] to build the entire list of formatted [ListTile]s
    List<Widget> _buildRows(List<Event> eList) {
      List<Widget> rows = [];

      for (var e in eList) {
        rows.add(_rowFactory(e));
        rows.add(Divider());

        /// spacer between each [ListTile]
      }

      return rows;
    }

    return FutureBuilder(
      future: db.getHomelistData(),
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Contact Tracer Events'),
              actions: <Widget>[
                Container(
                  padding: EdgeInsets.all(8),
                  child: RaisedButton(
                    onPressed: () {
                      _pushAddEvent(snapshot.data);
                    },
                    color: accentColor,
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            body: ListView(
              children: _buildRows(snapshot.data),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Contact Tracer Events'),
            ),
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
