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
        brightness: Brightness.dark, /// Overall app brightness

        primarySwatch: Colors.blueGrey, /// Helps with the widgets inheriting app colors

        primaryColor: primaryColor,

        primaryColorBrightness: Brightness.dark, /// Makes [Text] that appears on top [light]

        accentColor: accentColor,

        accentColorBrightness: Brightness.light, /// Makes [Text] that appears on top [dark]
        
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeList(),
    );
  }
}