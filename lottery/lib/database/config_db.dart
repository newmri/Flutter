import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:lottery/model/config_model.dart';

const String dbName = 'config.db';
const String tableName = 'Config';

class ConfigDB{
  static Database? _database;

  Future<Database> get database async {
    if(null != _database) return _database!;

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), dbName);

    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE $tableName(
            kind INTEGER PRIMARY KEY,
            value INTEGER,
          )
        ''');
        },
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }
  
  void insert(ConfigModel config) async {
    final db = await database;
    
    await db.insert(tableName, config.toMap());
  }
}