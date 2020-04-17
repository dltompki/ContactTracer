import 'package:contact_tracer/contactTracer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddDateAndTime extends StatefulWidget {
  Function updateInputDateAndTime;

  AddDateAndTime(Function updateInputDateAndTime) {
    this.updateInputDateAndTime = updateInputDateAndTime;
  }
  @override
  _AddDateAndTimeState createState() => _AddDateAndTimeState();
}

class _AddDateAndTimeState extends State<AddDateAndTime> {
  static TimeOfDay _selectedTime;
  static DateTime _selectedDate;

  static DateFormat myFormat = DateFormat('EEEE, M/d/y');
  static DefaultMaterialLocalizations local = DefaultMaterialLocalizations();

  static String _inputTime = local.formatTimeOfDay(TimeOfDay.now());
  static String _inputDate = myFormat.format(DateTime.now());

  String get inputDate => _inputDate;

  String get inputTime => _inputTime;

  void pickDateAndStore() async {
    _selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    setState(() {
      if (_selectedDate != null) {
        _inputDate = myFormat.format(_selectedDate);
        widget.updateInputDateAndTime(inputDate: _inputDate);
      }
    });
  }

  void pickTimeAndStore() async {
    _selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    setState(() {
      if (_selectedTime != null) {
        _inputTime = _selectedTime.toString();
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
                child: Text(_inputDate),
                color: accentColor,
                colorBrightness: Brightness.light,
                onPressed: () {
                  pickDateAndStore();
                },
              ),
            ]),
            Row(children: [
              Text('Time: '),
              RaisedButton(
                child: Text(_inputTime),
                color: accentColor,
                colorBrightness: Brightness.light,
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
