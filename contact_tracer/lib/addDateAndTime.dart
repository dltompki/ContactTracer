import 'package:flutter/material.dart';

class AddDateAndTime extends StatefulWidget {
  Function updateInputDateAndTime;
  
  AddDateAndTime(Function updateInputDateAndTime) {
    this.updateInputDateAndTime  = updateInputDateAndTime;
  }
  @override
  _AddDateAndTimeState createState() => _AddDateAndTimeState();
}

class _AddDateAndTimeState extends State<AddDateAndTime> {
  static TimeOfDay _selectedTime;
  static DateTime _selectedDate;

  static String _inputTime = TimeOfDay.now().toString();
  static String _inputDate = DateTime.now().toUtc().toString();

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
        _inputDate = _selectedDate.toUtc().toString();
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
                onPressed: () {
                  pickDateAndStore();
                },
              ),
            ]),
            Row(children: [
              Text('Time: '),
              RaisedButton(
                child: Text(_inputTime),
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
