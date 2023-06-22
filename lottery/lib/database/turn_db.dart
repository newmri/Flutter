import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:lottery/model/lottery_turn_model.dart';

const String dbName = 'turn.db';
const String tableName = 'winHistory';

class TurnDB {
  static Database? _database;

  Future<Database> get database async {
    if (null != _database) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future _initDB() async {
    String path = join(await getDatabasesPath(), dbName);

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join('assets', dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path);
  }

  Future<List<LotteryTurnModel>> get() async {
    final db = await database;

    var result = await db.query(tableName);

    return result.isNotEmpty
        ? result.map((e) => LotteryTurnModel.fromMap(e)).toList()
        : [];
  }

  void insert(LotteryTurnModel turnModel) async {
    final db = await database;

    await db.insert(tableName, turnModel.toMap());
  }

}
