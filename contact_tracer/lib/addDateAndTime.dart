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
  static TimeOfDay _selectedTime;
  static DateTime _selectedDate;

  static Utility util = Utility();

  static TimeOfDay _inputTime = TimeOfDay.now();
  static DateTime _inputDate = DateTime.now();

  _AddDateAndTimeState(Function updateInputDateAndTime) {
    updateInputDateAndTime(
      inputDate: _inputDate,
      inputTime: _inputTime,
    );
  }

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
                child: Text(util.formatDate(_inputDate)),
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
                child: Text(util.formatTime(_inputTime)),
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
