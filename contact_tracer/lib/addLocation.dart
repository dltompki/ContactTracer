import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'locationRequirements/locationPermission.dart';
import 'locationRequirements/locationService.dart';

class AddLocation extends StatefulWidget {
  Function updateInputLocation;

  AddLocation(Function updateInputLocation) {
    this.updateInputLocation = updateInputLocation;
  }

  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  LocationPermission perm = new LocationPermission();
  LocationService serv = new LocationService();

  final Location location = new Location();
  LocationData locationData;

  String displayLocation = 'unknown';
  String _error;

  Future<void> _getLocation() async {
    if (perm.getStatus() && serv.getStatus()) {
      locationData = await location.getLocation();
        displayLocation = locationData.toString();
    } else {
        displayLocation = 'Location Not Enabled';
    }
  }

  @override
  Widget build(BuildContext context) {
    _getLocation();
    
    return Card(
      child: ListTile(
        leading: Icon(Icons.place),
        title: Text(displayLocation),
        trailing: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              _getLocation();
            });
          },
        ),
      ),
    );
  }
}
