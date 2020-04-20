import 'package:flutter/material.dart';
import 'event.dart';
import 'utility.dart';

class Details {
  BuildContext context;
  Event e;
  Utility util = Utility();

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
        subtitle: Text(e.locationName), //TODO add map view
      ),
    );

    Card person = Card(
      child: ListTile(
        title: Text('Person'),
        subtitle: Text(e.person),
      ),
    );

    Card date = Card(
      child: ListTile(
        title: Text('Date'),
        subtitle: Text(e.formatDate),
      ),
    );

    Card time = Card(
      child: ListTile(
        title: Text('Date'),
        subtitle: Text(e.formatTime),
      ),
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
          body: ListView(
            children: [
              map,
              location,
              person,
              date,
              time,
            ],
          ),
        );
      },
    );
  }
}
