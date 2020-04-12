import 'package:flutter/material.dart';
import 'event.dart';
import 'details.dart';

class HomeList extends StatefulWidget {
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {

  Event event1 = new Event('London Bridge', 'The Queen', 'Tuesday');
  Event event2 = new Event('Home', 'Dallas', 'Wednesday');
  Event event3 = new Event('Five Guys', 'Drew', 'Thursday');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Contact Tracer Events'),
      ),
      body: ListView(
        children: [
          _buildRow(event1),
          Divider(),
          _buildRow(event2),
          Divider(),
          _buildRow(event3),
        ]

      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add New Event',
        child: Icon(Icons.add),
        onPressed: _pushAddEvent,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildRow(Event e) {
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.place),
        color: Colors.greenAccent[200],
        onPressed: () => _pushDetails(e),
      ),
      title: Text(e.location),
      subtitle: Text(e.person),
      trailing: Text(e.date),
    );
  }

  void _pushDetails(Event e) {
    Navigator.of(context).push(new Details(context, event: e).getRoute());
  }

  void _pushAddEvent() {
    
  }
}