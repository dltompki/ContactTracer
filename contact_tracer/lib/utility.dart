import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Utility {
  static final local = DefaultMaterialLocalizations();

  // Custom format for date througout the app. Should be used everywhere the date is displayed to the user, if possible.
  static final myFormat = DateFormat('EEEE, M/d/y');

  /// Formats the time of day according to local time zone in AM/PM
  static String formatTime(TimeOfDay time) {
    return local.formatTimeOfDay(time);
  }

  /// Formats date according to custom date format 
  static String formatDate(DateTime date) {
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

  static FlatButton createOkButton([Function onPressed]) {
    return FlatButton(
      child: Text("OK"),
      onPressed: () {
        if (onPressed != null) onPressed();
      },
    );
  }

  static FlatButton createCancelButton([Function onPressed]) {
    return FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        if (onPressed != null) onPressed();
      },
    );
  }

  static String appendToDelimitedString(
      final existingString, final newString, final delimiter) {
    return existingString +
        ((existingString.length > 0) ? delimiter + ' ' : '') +
        newString;
  }
}
