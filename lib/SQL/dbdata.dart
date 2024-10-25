import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;


  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'demo.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,desc TEXT)
      ''');
    });
  }

  Future<void> insertItem(String name,String desc) async {
    final db = await database;
    await db.insert('items', {'name': name ,"desc": desc});
  }

  Future<List<Map<String, dynamic>>> fetchItems() async {
    final db = await database;
    return await db.query('items');
  }

  Future<void> updateItem(int id, String name, String desc) async {
    final db = await database;
    await db.update('items', {'name': name,'desc':desc}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
