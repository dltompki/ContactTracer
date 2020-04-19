import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'locationRequirements/locationPermission.dart';
import 'locationRequirements/locationService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:search_map_place/search_map_place.dart';

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
  LatLng _latLng;
  Coordinates get _coords => _generateCoords(_latLng);

  Coordinates _generateCoords(LatLng _latLng) {
    return Coordinates(_latLng.latitude, _latLng.longitude);
  }

  Future<LocationData> _getLocation() async {
    if (await perm.requestStatus() && await serv.requestStatus()) {
      return await location.getLocation();
    }
  }

  Set<Marker> _markers = Set<Marker>();
  String _displayAddress = '';

  Future<CameraPosition> _getMapInfo() async {
    if (_latLng == null) {
      LocationData locationData = await _getLocation();
      _latLng = LatLng(locationData.latitude, locationData.longitude);
    }

    _markers.clear();
    _markers.add(
      Marker(
        markerId: MarkerId('Add Event Here'),
        position: _latLng,
      ),
    );

    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(_coords);
    _displayAddress = addresses.first.addressLine;

    return CameraPosition(
      target: _latLng,
      zoom: 18,
    );
  }

  GoogleMapController _controller;

  void _updateMap() {
    _controller.animateCamera(CameraUpdate.newLatLng(_latLng));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraPosition>(
      future: _getMapInfo(),
      builder: (BuildContext context, AsyncSnapshot<CameraPosition> snapshot) {
        if (snapshot.hasData) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.place),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SearchMapPlaceWidget(
                    apiKey: 'AIzaSyCraW0yH_H7YW0BdD5a4-56_TxFrzN5jNA',
                    onSelected: (Place _place) async {
                      Geolocation geo = await _place.geolocation;
                      setState(() {
                        _latLng = geo.coordinates;
                      });
                      _updateMap();
                    },
                  ),
                  SizedBox(
                    height: 300,
                    width: 200,
                    child: GoogleMap(
                      initialCameraPosition: snapshot.data,
                      mapType: MapType.hybrid,
                      myLocationEnabled: false,
                      markers: _markers,
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                    ),
                  ),
                ],
              ),
              subtitle: Text(_displayAddress),
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
                  height: 300, width: 200, child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }
}
