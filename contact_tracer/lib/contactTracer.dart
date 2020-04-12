import 'package:flutter/material.dart';
import 'homeList.dart';

class ContactTracer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Tracer',
      theme: ThemeData(
        brightness: Brightness.dark,

        primaryColor: Colors.blue[800],

        accentColor: Colors.indigoAccent,
        
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeList(),
    );
  }
}