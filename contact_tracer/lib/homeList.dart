import 'package:flutter/material.dart';
import 'event.dart';
import 'details.dart';
import 'addEvent.dart';
import 'contactTracer.dart';

class HomeList extends StatefulWidget {
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  var eventList = List<Event>();

  List<String> _getPeople() {
    var people = List<String>();
    eventList.forEach((event) {
      people.add(event.person);
    });
    return people;
  }

  @override
  Widget build(BuildContext context) {
    void _pushDetails(Event e) {
      Navigator.of(context).push(new Details(context, event: e).getRoute());
    }

    Widget _rowFactory(Event e) {
      return ListTile(
        leading: Icon(Icons.place, color: accentColor),
        title: Text(e.location),
        subtitle: Text(e.person),
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

    List<Widget> _buildRows(List<Event> eList) {
      List<Widget> rows = [];

      for (var e in eList) {
        rows.add(_rowFactory(e));
        rows.add(Divider());
      }

      return rows;
    }

    void addEventToList(Event e) {
      setState(() {
        eventList.add(e);
      });
    }

    void _pushAddEvent() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return new AddEvent(_getPeople(), addEventToList);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Tracer Events'),
      ),
      body: ListView(
        children: _buildRows(eventList),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add New Event',
        child: Icon(Icons.add),
        onPressed: _pushAddEvent,
      ),
    );
  }
}
