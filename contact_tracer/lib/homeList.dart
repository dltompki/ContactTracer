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
  List<Event> eventList = [
    Event('London Bridge', 'The Queen', 'Tuesday', '3:00 PM'),
    Event('Home', 'Dallas', 'Wednesday', '11:59 AM'),
    Event('Five Guys', 'Drew', 'Thursday', '7:35 PM'),
  ];

  @override
  Widget build(BuildContext context) {
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
      leading: Icon(Icons.place, color: accentColor),
      title: Text(e.location),
      subtitle: Text(e.person),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(e.date),
          Text(e.time),
        ],
      ),
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return new AddEvent(addEventToList);
        },
      ),
    );
  }
}
