import 'package:flutter/material.dart';

class AddLocation extends StatefulWidget {
  Function updateInputLocation;

  AddLocation(Function updateInputLocation) {
    this.updateInputLocation = updateInputLocation;
  }

  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.place),
        title: TextField(
          decoration: InputDecoration(labelText: 'Location'),
          onChanged: (String value) {
            widget.updateInputLocation(value);
          },
        ),
      ),
    );
  }
}