import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'event.dart';
import 'contactTracer.dart';
import 'details.dart';

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

  /// Builds a list of [Divider]s and [ListTile]s in the format used in both the [HomeList] and [FilterPersonView]
  static List<Widget> buildRows(BuildContext context, List<Event> eList) {
    List<Widget> rows = [];

    for (var e in eList) {
      rows.add(_rowFactory(context, e));
      rows.add(Divider());

      /// spacer between each [ListTile]
    }

    return rows;
  }

  /// Format for [ListTile] used in [HomeList] and [FilterPersonView]
  static Widget _rowFactory(BuildContext context, Event e) {
    return ListTile(
      leading: Icon(Icons.place, color: accentColor),
      title: Text(e.locationName),
      subtitle: Text(e.formattedPeople),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(e.formatDate),
          Text(e.formatTime),
        ],
      ),
      onTap: () => {_pushDetails(context, e)},
    );
  }

  /// Opens the [Details] screen for the [Event] that was clicked on
  static void _pushDetails(BuildContext context, Event e) {
    Navigator.of(context).push(new Details(
      context,
      event: e,
    ).getRoute());
  }
}
