import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
}
