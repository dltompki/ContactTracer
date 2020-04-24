import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'event.dart';
import 'addEvent.dart';

class EventDatabase {
  final Future<Database> database;
  EventDatabase() : database = initDatabase();

  static Future<Database> initDatabase() async {
    return openDatabase(
      /// Set path to database
      join(await getDatabasesPath(), 'event_database.db'),

      /// Only when database is first created, make a table for events
      onCreate: (db, version) {
        /// Create the table with columns specific to how the event object is set up
        return db.execute(
          "CREATE TABLE events(id INTEGER, latitude INTEGER," +
              " longitude  INTEGER, locationName STRING, people STRING," +
              " person STRING, date STRING, hour INTEGER, minute INTEGER)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  // Define a function that inserts events into the database
  Future<void> insertEvent(Map<String, dynamic> event) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'events',
      event,
    );
  }

  List<Event> _parseMaps(List<Map<String, dynamic>> maps) {
    List<Event> _output = [];

    List.generate(maps.length, (index) {
      _output.add(Event.parse(maps[index]));
    });

    return _output;
  }

  Future<List<Event>> getUnfilteredEvents() async {
    /// Get database refrence
    final Database db = await database;

    /// Get all the maps in the events table
    final List<Map<String, dynamic>> maps = await db.query('events');

    /// Parse maps into events
    final List<Event> unfilteredEvents = _parseMaps(maps);

    return unfilteredEvents;
  }

  Future<List<Event>> getFilteredEvents({List<Event> eventList}) async {
    List<Event> unfilteredEvents;

    /// Get all events from database
    if (eventList == null) {
      unfilteredEvents = await getUnfilteredEvents();
    } else {
      unfilteredEvents = eventList;
    }

    /// Define list of events we will return
    List<Event> filteredEvents = [];

    /// Define list of ids that have already been entered into the filteredEvents list
    List<int> ids = [];

    unfilteredEvents.forEach((e) {
      if (!ids.contains(e.id)) {
        ids.add(e.id);
        filteredEvents.add(e);
      }
    });

    return filteredEvents;
  }

  Future<List<String>> getAllPeople() async {
    /// Get all events from the database
    List<Event> unfilteredEvents = await getUnfilteredEvents();

    /// Define list of people we will return
    List<String> peopleOutput = [];

    /// Interate over [unfilteredEvents] and add a person to the list if they arent already on it
    unfilteredEvents.forEach((event) {
      List<String> people = event.formattedPeople.split(AddEvent.personDelimiter);
      for (var i = 0; i < people.length; i++) {
        people[i] = people[i].trim();
      }

      people.forEach((person) {
        if (!peopleOutput.contains(person)) {
          peopleOutput.add(person);
        }
      });
    });

    return peopleOutput;
  }

  Future<List<Event>> getEventsByPeople(List<String> people) async {
    // Get database refrence
    // final Database db = await database;

    // List<Map<String, dynamic>> allMaps = [];

    // Query for events that have the people
    // people.forEach((person) async {
    //   final List<Map<String, dynamic>> maps =
    //       await db.query('events', where: 'person = ?', whereArgs: [person]);

    //   maps.forEach((map) {
    //     allMaps.add(map);
    //   });
    // });

    // final List<Event> unfilteredEvents = _parseMaps(allMaps);

    // get all events
    final List<Event> unfilteredEvents = await getUnfilteredEvents();

    List<Event> eventsByPeople = [];
    
    unfilteredEvents.forEach((event) {
      people.forEach((person) {
        if(event.person == person) {
          eventsByPeople.add(event);
        }
      });
    });

    return getFilteredEvents(eventList: eventsByPeople);
  }
}
