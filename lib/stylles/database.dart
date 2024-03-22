import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('traffic.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE feeds (
  id $idType,
  createdAt $textType,
  entryId $integerType,
  field1 $textType
)
''');
  }

  Future<void> insertFeed(Feed feed) async {
    final db = await instance.database;
    await db.insert('feeds', feed.toJson());
  }

  Future<List<Feed>> fetchFeeds() async {
    final db = await instance.database;
    final result = await db.query('feeds');
    return result.map((json) => Feed.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
