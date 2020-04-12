import 'package:flutter/material.dart';
import 'event.dart';
import 'details.dart';
import 'addEvent.dart';

class HomeList extends StatefulWidget {
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  List<Event> eventList = [
    Event('London Bridge', 'The Queen', 'Tuesday'),
    Event('Home', 'Dallas', 'Wednesday'),
    Event('Five Guys', 'Drew', 'Thursday'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Contact Tracer Events'),
      ),
      body: ListView(
        children: _buildRows(eventList),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add New Event',
        child: Icon(Icons.add),
        onPressed: _pushAddEvent,
      ), // This trailing comma makes auto-formatting nicer for build methods.
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

  Widget _rowFactory(Event e) {
    return ListTile(
      leading: Icon(Icons.place, color: Colors.greenAccent[200],),
      title: Text(e.location),
      subtitle: Text(e.person),
      trailing: Text(e.date),
      onTap: () => {_pushDetails(e)},
    );
  }

  void _pushDetails(Event e) {
    Navigator.of(context).push(new Details(context, event: e).getRoute());
  }

  void addEventToList(Event e) {
    setState(() {
      eventList.add(e);
    });
  }

  void _pushAddEvent() {
    Navigator.of(context)
        .push(new AddEvent(context, callback: addEventToList).getRoute());
  }
}
