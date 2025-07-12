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
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'assets.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE assets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ticker TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        average_price REAL NOT NULL
      )
    ''');
  }

  // Inserir ativo
  Future<int> insertAsset(Map<String, dynamic> asset) async {
    final db = await database;
    return await db.insert('assets', asset);
  }

  // Buscar todos os ativos
  Future<List<Map<String, dynamic>>> getAllAssets() async {
    final db = await database;
    return await db.query('assets');
  }

  // Atualizar ativo
  Future<int> updateAsset(int id, Map<String, dynamic> asset) async {
    final db = await database;
    return await db.update('assets', asset, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAsset(int id) async {
    final db = await database;
    return await db.delete('assets', where: 'id = ?', whereArgs: [id]);
  }
}
