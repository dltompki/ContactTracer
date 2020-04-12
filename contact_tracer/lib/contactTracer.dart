import 'package:flutter/material.dart';
import 'homeList.dart';

class ContactTracer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Tracer',
      theme: ThemeData(
        brightness: Brightness.dark,

        primaryColor: Colors.blueGrey[700],

        accentColor: Colors.greenAccent[200],
        
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeList(),
    );
  }
}