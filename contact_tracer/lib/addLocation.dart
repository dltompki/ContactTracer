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
  static LocationPermission perm = LocationPermission();
  static LocationService serv = LocationService();

  static final Location location = new Location();
  static LocationData locationData;

  static String displayLocation;

  static Future<void> getLocation() async{
    if(perm.status && serv.status) {
      locationData = await location.getLocation();
    } else {
      displayLocation = 'Location Not Enabled';
    }
    
  }

  @override
  Widget build(BuildContext context) {
    getLocation();
    return Card(
      child: ListTile(
        leading: Icon(Icons.place),
        title: Text(displayLocation),
      ),
    );
  }
}