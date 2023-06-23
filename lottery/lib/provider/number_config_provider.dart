import 'package:flutter/cupertino.dart';
import 'package:lottery/model/config_model.dart';
import 'package:lottery/database/config_db.dart';

enum ConfigKind {
  statics,
  overGenerate,
  minTurn,
  maxTurn,
}

class NumberConfigProvider extends ChangeNotifier {
  final ConfigDB _configDB = ConfigDB(tableName: 'numberConfig');

  late List<ConfigModel> _configList = [];

  Future<void> init(int minTurn, int maxTurn) async {
    if (_configList.isNotEmpty) {
      return;
    }

    _configList = await _configDB.get();

    notifyListeners();

    for (var e in ConfigKind.values) {
      ConfigModel configModel;

      if (ConfigKind.minTurn == e) {
        configModel = ConfigModel(id: e.index, value: minTurn);
      } else if (ConfigKind.maxTurn == e) {
        configModel = ConfigModel(id: e.index, value: maxTurn);
      } else {
        configModel = ConfigModel(id: e.index, value: 0);
      }

      _configList.add(configModel);
      _configDB.insert(configModel);
    }
  }

  bool isOnLoading() {
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
