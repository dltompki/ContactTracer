import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'eventDatabase.dart';
import 'package:location/location.dart';
import 'event.dart';
import 'details.dart';

class MapView extends StatelessWidget {
  EventDatabase db = new EventDatabase();
  Location location = new Location();

  /// Creates a [Set<Marker>] from the [events] to be displayed on the [GoogleMap]
  Set<Marker> _getMarkers(BuildContext context, List<Event> events) {
    Set<Marker> output = {};

    events.forEach(
      (event) {
        output.add(
          Marker(
            markerId: MarkerId(event.id.toString()),
            position: LatLng(event.location.latitude, event.location.longitude),
            consumeTapEvents: true,
            onTap: () {
              Navigator.of(context)
                  .push(new Details(context, event: event).getRoute());
            },
          ),
        );
      },
    );

    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Map View'),
      ),
      body: FutureBuilder(
        future: db.getFilteredEvents(),

        /// returns all events in database, with no duplicates (same as [HomeList])
        builder: (BuildContext context, AsyncSnapshot<List<Event>> events) {
          if (events.hasData) {
            return FutureBuilder(
              future: location.getLocation(),

              /// returns device's current location for the [target] of the [GoogleMap]
              builder: (BuildContext context,
                  AsyncSnapshot<LocationData> locationData) {
                if (locationData.hasData) {
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(locationData.data.latitude,
                          locationData.data.longitude),
                      zoom: 12,
                    ),
                    mapType: MapType.hybrid,
                    myLocationEnabled: true,
                    markers: _getMarkers(context, events.data),
                  );
                } else {
                  return Loading();
                }
              },
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}

/// Custom [CircularProgressIndicator] because it looks bettter. Also used in [FilterPersonView]
class Loading extends StatelessWidget {
  const Loading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularProgressIndicator(
        strokeWidth: 15,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(100),
    );
  }
}
