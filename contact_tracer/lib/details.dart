import 'package:flutter/material.dart';
import 'event.dart';
import 'utility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Details {
  BuildContext context;
  Event e;
  Utility util = Utility();

  /// Default constructor reqires an [Event] to build a detailed view of its data
  Details(BuildContext context, {@required Event event}) {
    this.context = context;
    this.e = event;
  }

  MaterialPageRoute getRoute() {
    /// Creates a square (realtive to device screen size) [GoogleMap] which displays a [Marker] on the [location] of the [Event]
    Card map = Card(
      child: Container(
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: util.coordsToLatLng(e.location),
            zoom: 18, // TODO figure out how to make this responsive to the place being viewed
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

    /// Since all the [Details] screen does is display static information, these cards could have a factory.
    /// I'm not bothering right now because editing still needs to be implemented and I think they may
    /// be more different after that.

    Card location = Card(
      child: ListTile(
        title: Text('Location'),
        subtitle: Text(e.locationName),
      ),
    );

    Card person = Card(
      child: ListTile(
        title: Text('Person'),
        subtitle: Text(e.formattedPeople),
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
