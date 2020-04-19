import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'locationRequirements/locationPermission.dart';
import 'locationRequirements/locationService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddLocation extends StatefulWidget {
  final Function updateInputLocation;

  AddLocation(Function updateInputLocation)
      : this.updateInputLocation = updateInputLocation;

  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  LocationPermission perm = new LocationPermission();
  LocationService serv = new LocationService();

  final Location location = new Location();
  LocationData locationData;

  String displayLocation = 'unknown';

  Future<LocationData> _getLocation() async {
    if (await perm.requestStatus() && await serv.requestStatus()) {
      return await location.getLocation();
    }
  }

  Set<Marker> _markers = Set<Marker>();

  Future<CameraPosition> _getCamPos() async {
    LocationData locationData = await _getLocation();

    LatLng coords = LatLng(locationData.latitude, locationData.longitude);

    if (_markers != null) {
    _markers.clear();
    }

    _markers.add(
      Marker(
        markerId: MarkerId('Add Event Here'),
        position: coords,
      ),
    );

    return CameraPosition(
      target: coords,
      zoom: 18,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraPosition>(
      future: _getCamPos(),
      builder: (BuildContext context, AsyncSnapshot<CameraPosition> snapshot) {
        if (snapshot.hasData) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.place),
              // title: Text(snapshot.data.toString()),
              // trailing: IconButton(
              //   icon: Icon(Icons.refresh),
              //   onPressed: () {
              //     setState(() {
              //       _getLocation();
              //     });
              //   },
              // ),
              title: SizedBox(
                height: 300,
                width: 200,
                child: GoogleMap(
                  initialCameraPosition: snapshot.data,
                  mapType: MapType.hybrid,
                  myLocationEnabled: true,
                  markers: _markers,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.place),
              title: Text(snapshot.error.toString()),
            ),
          );
        } else {
          return Card(
            child: ListTile(
              leading: Icon(Icons.place),
              title: SizedBox(
                height: 300,
                width: 200,
                child:CircularProgressIndicator()
              ),
            ),
          );
        }
      },
    );
  }
}
