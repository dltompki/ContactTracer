import 'package:flutter/material.dart';

class FilterPersonView extends StatefulWidget {
  @override
  _FilterPersonViewState createState() => _FilterPersonViewState();
}

class _FilterPersonViewState extends State<FilterPersonView> {
  List<String> selectedPeople = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Filter By Person'),
      ),
      body: Column(
        children: [
          Card(
            child: ExpansionPanelList(
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    if (selectedPeople.length > 0) {
                      // TODO build formatted title using utility function dad made
                    } else {
                      return Text('Select Person(s)');
                    }
                  },
                  body: , // TODO checklist based on map derived from all people passed in
                  canTapOnHeader: true,
                ),
              ],
            ),
          ),
          Card(
            child: FutureBuilder(builder: null), // TODO query database using selected people list to build a listview of events
          ),
        ],
      ),
    );
  }
}