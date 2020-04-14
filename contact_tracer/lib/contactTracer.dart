import 'package:flutter/material.dart';
import 'homeList.dart';

final primaryColor = Colors.blueGrey[700];
final accentColor = Colors.greenAccent[200];

class ContactTracer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Tracer',
      theme: ThemeData(
        brightness: Brightness.dark,

        primaryColor: primaryColor,

        accentColor: accentColor,
        
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeList(),
    );
  }
}