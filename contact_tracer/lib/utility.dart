import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utility {
  var local = DefaultMaterialLocalizations();
  DateFormat myFormat = DateFormat('EEEE, M/d/y');


  String formatTime(TimeOfDay time) {
    return local.formatTimeOfDay(time);
  }

  String formatDate(DateTime date) {
    return myFormat.format(date);
  }
} 