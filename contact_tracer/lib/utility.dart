import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utility {
  static final local = DefaultMaterialLocalizations();
  static final myFormat = DateFormat('EEEE, M/d/y');

  static String formatTime(TimeOfDay time) {
    return local.formatTimeOfDay(time);
  }

  static String formatDate(DateTime date) {
    return myFormat.format(date);
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
