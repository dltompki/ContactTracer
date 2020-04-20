import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Utility {
  var local = DefaultMaterialLocalizations();

  // Custom format for date througout the app. Should be used everywhere the date is displayed to the user, if possible.
  DateFormat myFormat = DateFormat('EEEE, M/d/y');

  /// Formats the time of day according to local time zone in AM/PM
  String formatTime(TimeOfDay time) {
    return local.formatTimeOfDay(time);
  }

  /// Formats date according to custom date format 
  String formatDate(DateTime date) {
    return myFormat.format(date);
  }

  /// Converts from google maps [LatLng] to dart [Coordinates]
  Coordinates latLngToCoords(LatLng latLng) {
    return Coordinates(latLng.latitude, latLng.longitude);
  }

  /// Converts from dart [Coordinates] to google maps [LatLng]
  LatLng coordsToLatLng(Coordinates coords) {
    return LatLng(coords.latitude, coords.longitude);
  }
} 