import 'package:flutter/cupertino.dart';
import 'package:lottery/model/config_model.dart';
import 'package:lottery/database/config_db.dart';

enum ConfigKind {
  statics,
  overGenerate,
}

class NumberConfigProvider extends ChangeNotifier {
  final ConfigDB _configDB = ConfigDB(tableName: 'numberConfig');

  late List<ConfigModel> _configList = [];

  Future<void> init() async {

    _configList = await _configDB.get();

    if (_configList.isNotEmpty) {
      return;
    }

    for (var e in ConfigKind.values) {
      var config = ConfigModel(id: e.index, value: 0);
      _configList.add(config);
      _configDB.insert(config);
    }
  }

  bool isOnLoading(){
    return _configList.isEmpty;
  }

  int getValue(ConfigKind kind) {
    return _configList[kind.index].value;
  }

  void setValue(ConfigKind kind, int value) {
    _configList[kind.index].value = value;

    notifyListeners();

    _configDB.update(_configList[kind.index]);
  }
}
