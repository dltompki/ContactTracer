import 'package:flutter/material.dart';
import 'event.dart';
import 'utility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: util.coordsToLatLng(e.location),
            zoom: 18,
          ),
          markers: Set.from([
            Marker(
              markerId: MarkerId(e.locationName),
              position: util.coordsToLatLng(e.location),
            )
          ]),
          mapType: MapType.hybrid,
        ),
      ),
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
        title: Text('Time'),
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
