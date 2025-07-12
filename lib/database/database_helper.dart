import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'assets.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE assets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ticker TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        average_price REAL NOT NULL,
        current_price REAL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE assets ADD COLUMN current_price REAL');
    }
  }

  Future<int> insertAsset(Map<String, dynamic> asset) async {
    final db = await database;
    return db.insert('assets', asset);
  }

  Future<int> updateAsset(Map<String, dynamic> asset) async {
    final db = await database;
    return db.update(
      'assets',
      asset,
      where: 'id = ?',
      whereArgs: [asset['id']],
    );
  }

  Future<int> deleteAsset(int id) async {
    final db = await database;
    return db.delete('assets', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllAssets() async {
    final db = await database;
    return db.query('assets');
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('assets');
  }
}
