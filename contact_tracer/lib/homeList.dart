import 'package:flutter/material.dart';

class HomeList extends StatefulWidget {
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
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
          _buildRow('London Bridge', 'The Queen', 'Tuesday'),
          Divider(),
          _buildRow('Home', 'Dallas', 'Wednesday'),
          Divider(),
          _buildRow('Five Guys', 'Drew', 'Thursday'),
        ]

      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add New Event',
        child: Icon(Icons.add),
        onPressed: _pushAddEvent,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildRow(location, person, date) {
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.place),
        color: Colors.blue[800],
        onPressed: _pushDetails,
      ),
      title: Text(location),
      subtitle: Text(person),
      trailing: Text(date),
    );
  }

  void _pushDetails() {

  }

  void _pushAddEvent() {
    
  }
}