import 'package:flutter/material.dart';
import 'event.dart';

class Details {

  BuildContext context;
  Event e;

  Details(BuildContext context, {Event event}) {
    this.context = context;
    this.e = event;
  }

  MaterialPageRoute getRoute() {

    Card map = Card(
      child: Placeholder(),
    );

    Card location = Card(
      child: ListTile(
        title: Text('Location'),
        subtitle: Text(e.location),
      )
    );

    Card person= Card(
      child: ListTile(
        title: Text('Person'),
        subtitle: Text(e.person),
      )
    );

    Card date= Card(
      child: ListTile(
        title: Text('Date'),
        subtitle: Text(e.date),
      )
    );

    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Event Details'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back), 
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(32),
            child: ListView(
              children: [
                map,
                location,
                person,
                date,
              ],
            ),
          ),
        );
      }
    );
  }
}