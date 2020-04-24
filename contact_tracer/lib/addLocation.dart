import 'package:contact_tracer/contactTracer.dart';
import 'package:contact_tracer/utility.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
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
  /// Requirements for [Location.getLocation] to work
  LocationPermission perm = new LocationPermission();
  LocationService serv = new LocationService();

  Utility util = Utility();

  final Location location = new Location();
  LatLng _latLng;

  /// Convience getter because [GoogleMap] uses [LatLng] while the dart default is [Coordinates]
  Coordinates get _coords => util.latLngToCoords(_latLng);

  /// Gets current GPS location if service is enabled and permission is granted
  Future<LocationData> _getLocation() async {
    if (await perm.requestStatus() && await serv.requestStatus()) {
      return await location.getLocation();
    }
  }

  Set<Marker> _markers = Set<Marker>();
  String _displayAddress = '';

  /// Returns the camera position to update tha map while also updating the [Marker] and [_displayAddress]
  Future<CameraPosition> _getMapInfo() async {
    /// On the first time being called, updates [_latLng] with current GPS location
    if (_latLng == null) {
      LocationData locationData = await _getLocation();
      _latLng = LatLng(locationData.latitude, locationData.longitude);
    }

    /// Keeps the list of [Marker]s updated with only the location that will be sent upon submission
    _markers.clear();
    _markers.add(
      Marker(
        markerId: MarkerId('Add Event Here'),
        position: _latLng,
      ),
    );

    /// Uses reverse geocoding to derive an address from GPS coodinates
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(_coords);

    /// TODO [Place.description] from the [search_map_place] may be better
    _displayAddress = addresses.first.addressLine;

    /// Sends up to date information back to [AddEvent]
    widget.updateInputLocation(_coords, _displayAddress);

    return CameraPosition(
      target: _latLng,
      zoom: 18,

      /// TODO make this responsive
    );
  }

  GoogleMapController _controller;

  /// Animates the changing of [_latLng] after a search
  void _updateMap() {
    _controller.animateCamera(CameraUpdate.newLatLng(_latLng));
  }

  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));

    try {
      await remoteConfig.fetch(expiration: const Duration(hours: 12));
      await remoteConfig.activateFetched();
    } on FetchThrottledException catch (exception) {
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }

    return remoteConfig;
  }

  @override
  Widget build(BuildContext context) {
    /// Waits for the [CameraPosition] to be retuned. Shows a [CircularProgressIndicator] while waiting.
    return FutureBuilder<CameraPosition>(
      future: _getMapInfo(),
      builder: (BuildContext context, AsyncSnapshot<CameraPosition> snapshot) {
        if (snapshot.hasData) {
          return Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.place,
                    color: accentColor,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FutureBuilder<RemoteConfig>(
                        future: setupRemoteConfig(),
                        builder: (BuildContext context,
                            AsyncSnapshot<RemoteConfig> remoteConfig) {
                          if (remoteConfig.hasData) {
                            return Container(
                              child: SearchMapPlaceWidget(
                                darkMode: true,
                                iconColor: accentColor,
                                apiKey: remoteConfig.data
                                    .getString('google_maps_key'),
                                onSelected: (Place _place) async {
                                  Geolocation geo = await _place.geolocation;
                                  setState(() {
                                    _latLng = geo.coordinates;
                                  });
                                  _updateMap();
                                },
                              ),
                              padding: EdgeInsets.only(bottom: 0, top: 4),
                            );
                          } else {
                            return LinearProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8),
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
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(_displayAddress),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Card(
            child: ListTile(
              leading: Icon(
                Icons.place,
                color: accentColor,
              ),
              title: RaisedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text('Load Location')
              ),
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
