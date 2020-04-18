import 'package:contact_tracer/event.dart';
import 'package:flutter/material.dart';
import 'addDateAndTime.dart';

class AddEvent extends StatefulWidget {
  Function addEventToList;

  AddEvent(Function addEventToList) {
    this.addEventToList = addEventToList;
  }

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  static String _inputLocation;
  static String _inputPerson;
  static DateTime _inputDate;
  static TimeOfDay _inputTime;

  static void updateInputDateAndTime({DateTime inputDate, TimeOfDay inputTime}) {
    if (inputTime != null) {
      _inputTime = inputTime;
    }

    if (inputDate != null) {
      _inputDate = inputDate;
    }
  }

  AddDateAndTime dateAndTime = new AddDateAndTime(updateInputDateAndTime);

  @override
  Widget build(BuildContext _context) {
    Card location = Card(
      child: ListTile(
        leading: Icon(Icons.place),
        title: TextField(
          decoration: InputDecoration(labelText: 'Location'),
          onChanged: (String value) {
            _inputLocation = value;
          },
        ),
      ),
    );

    var inputPersonTextEditingController = TextEditingController(
      text: (_inputPerson != null) ? _inputPerson : ''); // Configure text to a non-null value

    void _showMultiSelectDialog() async {
      Set<int> initialSelectedValues = Set();
      List<MultiSelectDialogItem<int>> items = <MultiSelectDialogItem<int>>[
        MultiSelectDialogItem(0, 'Dog'),
        MultiSelectDialogItem(1, 'Cat'),
        MultiSelectDialogItem(2, 'Mouse'),
      ];

      // Eliminate non-empty, blank line
      inputPersonTextEditingController.text = inputPersonTextEditingController.text.trim();

      // If input already exists, add to the list
      if (inputPersonTextEditingController.text.length > 0) {
        items.insert(
          items.length, 
          MultiSelectDialogItem(items.length, inputPersonTextEditingController.text));
      }

      // Present the list in sorted order for easy perusal
      items.sort((a, b) => a.label.compareTo(b.label));
      for (var i = 0; i < items.length; ++i) {
        items[i].index = i;
      }

      // Select inputted value by default
      for (var i in items) {
        if (i.label == inputPersonTextEditingController.text) 
          initialSelectedValues.add(i.index);
      }

      final selectedValues = await showDialog<Set<int>>(
        context: context,
        builder: (BuildContext context) {
          return MultiSelectDialog(
            items: items,
            initialSelectedValues: initialSelectedValues,
          );
        },
      );

      if ((selectedValues != null) && (selectedValues.length > 0)) {
        inputPersonTextEditingController.text = '';
        print('Selected values:');
        for (var i in selectedValues) {
            dynamic person = items.elementAt(i).label;
            print(person);
            inputPersonTextEditingController.text += 
              ((inputPersonTextEditingController.text.length > 0) ? ', ' : '') + person;
        }
      }
    }

    Card person = Card(
      child: ListTile(
        leading: Icon(Icons.person),
        title: TextField(
          decoration: InputDecoration(labelText: 'Person'),
          controller: inputPersonTextEditingController,
          onTap: () {
              _showMultiSelectDialog();
          },
          onChanged: (String value) {
            _inputPerson = value;
          },
        ),
      ),
    );

    void _submitNewEvent() {
      AlertDialog unfilledField = new AlertDialog(
        title: Text('Not All Text Fields Filled'),
        content: SingleChildScrollView(
          child: Text(
              'Please fill out the location, person, and date of you event.'),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );

      if ((_inputLocation != null) &&
          (_inputPerson != null) &&
          (_inputDate != null) &&
          (_inputTime != null)) {
        Event e =
            new Event(_inputLocation, _inputPerson, _inputDate, _inputTime);
        widget.addEventToList(e);
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          barrierDismissible: false, // force the user to have to press okay
          useRootNavigator: false,
          builder: (context) {
            return unfilledField;
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          location,
          person,
          dateAndTime,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: _submitNewEvent,
      ),
    );
  }
}

class MultiSelectDialogItem<V> {
  MultiSelectDialogItem(this.index, this.label);

  V index;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues}) : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select animals'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.index);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.index, checked),
    );
  }
}