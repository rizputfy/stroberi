import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/history_item.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  static Database? _database;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'stromate_history.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagePath TEXT,
            label TEXT,
            confidence REAL,
            dateTime TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertHistory(HistoryItem item) async {
    final db = await database;
    return await db.insert('history', item.toMap());
  }

  Future<List<HistoryItem>> getAllHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('history', orderBy: 'id DESC');
    return List.generate(maps.length, (i) => HistoryItem.fromMap(maps[i]));
  }
}
