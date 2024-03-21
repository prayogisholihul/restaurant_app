import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/restaurant.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;
  static const String _tableName = 'Restaurant';

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Restaurant.db');

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''CREATE TABLE $_tableName (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      pictureId TEXT NOT NULL,
      city TEXT NOT NULL,
      rating REAL NOT NULL
    )''');
  }

  Future<int> insert(Restaurant restaurant) async {
    final db = await instance.database;
    return await db.insert(_tableName, restaurant.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Restaurant>> getAll() async {
    final db = await instance.database;
    final get = await db.query(_tableName);
    return get.map((e) => Restaurant.fromLocal(e)).toList();
  }

  Future<Restaurant> get(String id) async {
    final db = await instance.database;
    final get = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    return Restaurant.fromLocal(get.first);
  }

  Future<int> delete(String id) async {
    final db = await instance.database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs:  [id]);
  }
}
