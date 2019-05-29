import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Name {
  final int id;
  final String firstName;
  final String lastName;

  Name({this.id, this.firstName, this.lastName});

  @override
  String toString() => "$id: $firstName $lastName";

  Map<String, dynamic> toMap() =>
      {'id': id, 'firstName': firstName, 'lastName': lastName};

}

Future<void> insertName(Name name) async {
  final Future<Database> database = openDatabase(
    // Set the path to the database.
    join(await getDatabasesPath(), 'namedatabase.db'),
    // When the database is first created, create a table to store dogs
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database
      return db.execute(
        "CREATE TABLE names(id INTEGER PRIMARY KEY ASC, firstName TEXT, lastName TEXT)",
      );
    } ,
    // Set t version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 2,
  );
  final db = await database;
  await db.insert(
      "names", name.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<Name>> names() async {
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'namedatabase.db'),
// When the database is first created, create a table to store dogs
/*    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE names(id INTEGER PRIMARY KEY, firstName TEXT, lastName TEXT)",
      );
    }, */
// Set the version. This executes the onCreate function and provides a
// path to perform database upgrades and downgrades.
    version: 2,
  );

  final Database db = await database;

  List<Map<String, dynamic>> maps = await db.query('names');
  return List.generate(maps.length, (i) {
  return Name(id: maps[i]['id'], firstName: maps[i]['firstName'], lastName: maps[i]['lastName']);
  });
}


