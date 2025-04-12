import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('all_items.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      description TEXT,
      imagePath TEXT,
      pixelHash TEXT
    )
  ''');
  }

  Future<void> insertItem(Item item) async {
    final db = await instance.database;
    await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Item>> getAllItems() async {
    final db = await instance.database;
    final result = await db.query('items');
    return result.map((e) => Item.fromMap(e)).toList();
  }
}
