import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Utility {
  var local = DefaultMaterialLocalizations();
  DateFormat myFormat = DateFormat('EEEE, M/d/y');


  String formatTime(TimeOfDay time) {
    return local.formatTimeOfDay(time);
  }

  String formatDate(DateTime date) {
    return myFormat.format(date);
  }

  Coordinates latLngToCoords(LatLng latLng) {
    return Coordinates(latLng.latitude, latLng.longitude);
  }

  LatLng coordsToLatLng(Coordinates coords) {
    return LatLng(coords.latitude, coords.longitude);
  }
} 