import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:lottery/model/config_model.dart';

const String dbName = 'config.db';

class ConfigDB {
  final String tableName;
  static Database? _database;

  ConfigDB({required this.tableName});

  Future<Database> get database async {
    if (null != _database) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future _initDB() async {
    String path = join(await getDatabasesPath(), dbName);

    return await openDatabase(path,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: (db, oldVersion, newVersion) {});
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY,
            value INTEGER
          )
         ''');
  }

  Future<List<ConfigModel>> get() async {
    final db = await database;

    var result = await db.query(tableName);

    return result.isNotEmpty
        ? result.map((e) => ConfigModel.fromMap(e)).toList()
        : [];
  }

  void insert(ConfigModel config) async {
    final db = await database;

    await db.insert(tableName, config.toMap());
  }

  void update(ConfigModel config) async {
    final db = await database;

    await db.update(tableName, config.toMap(),
        where: 'id = ?', whereArgs: [config.id]);
  }
}
