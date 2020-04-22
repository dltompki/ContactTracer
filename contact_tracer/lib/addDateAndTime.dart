import 'package:contact_tracer/contactTracer.dart';
import 'package:flutter/material.dart';
import 'utility.dart';

class AddDateAndTime extends StatefulWidget {
  final Function updateInputDateAndTime;

  AddDateAndTime(Function updateInputDateAndTime)
      : this.updateInputDateAndTime = updateInputDateAndTime;

  @override
  _AddDateAndTimeState createState() =>
      _AddDateAndTimeState(updateInputDateAndTime);
}

class _AddDateAndTimeState extends State<AddDateAndTime> {
  /// These variables allow the output of the date and time pickers to be read before updating the 
  /// [_inputDate] and [_inputTime], because if the user cancels the pick, the picker returns
  /// [null], and we don't want to submit either [_inputDate] or [_inputTime] as [null].
  static TimeOfDay _selectedTime;
  static DateTime _selectedDate;

  static Utility util = Utility();

  /// These variables are sent through the callback function [updateInputDateAndTime] backt o [AddEvent].
  static TimeOfDay _inputTime = TimeOfDay.now();
  static DateTime _inputDate = DateTime.now();

  /// Updates [AddEvent] with the current date and time so if the user wants to input the current moment,
  /// they don't even have to use the date or time pickers. This is also more intuitive because it is
  /// representative of the information being diaplyed to the user on the date and time buttons.
  _AddDateAndTimeState(Function updateInputDateAndTime) {
    updateInputDateAndTime(
      inputDate: _inputDate,
      inputTime: _inputTime,
    );
  }

  /// Calls [showDatePicker] with the current date being the default.
  /// If the user chooses a date and submits, the [_inputDate] is updated accordingly.
  /// If the user cancels, the date picker returns [null] and the [_inputDate] is not updated.
  void pickDateAndStore() async {
    _selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    setState(() {
      if (_selectedDate != null) {
        _inputDate = _selectedDate;
        widget.updateInputDateAndTime(inputDate: _inputDate);
      }
    });
  }

  /// Calls [showTimePicker] with the current time being the default.
  /// If the user chooses a time and submits, the [_inputTime] is updated accordingly.
  /// If the user cancels, the time picker returns [null] and the [_inputTime] is not updated.
  void pickTimeAndStore() async {
    _selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    setState(() {
      if (_selectedTime != null) {
        _inputTime = _selectedTime;
        widget.updateInputDateAndTime(inputTime: _inputTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.date_range),
        title: Column(
          children: [
            Row(children: [
              Text('Date: '),
              RaisedButton(
                child: Text(Utility.formatDate(_inputDate)),
                color: accentColor,
                colorBrightness: Brightness.light, /// Makes the [Text] on top dark, so its readable
                onPressed: () {
                  pickDateAndStore();
                },
              ),
            ]),
            Row(children: [
              Text('Time: '),
              RaisedButton(
                child: Text(Utility.formatTime(_inputTime)),
                color: accentColor,
                colorBrightness: Brightness.light, /// Makes the [Text] on top dark, so its readable
                onPressed: () {
                  pickTimeAndStore();
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
