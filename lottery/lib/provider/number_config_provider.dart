import 'package:flutter/cupertino.dart';
import 'package:lottery/model/config_model.dart';
import 'package:lottery/database/config_db.dart';

import 'number_provider.dart';

enum ConfigKind {
  statics,
  overGenerate,
  minTurn,
  maxTurn,
}

class NumberConfigProvider extends ChangeNotifier {
  final ConfigDB _configDB = ConfigDB(tableName: 'numberConfig');

  late List<ConfigModel> _configList = [];

  late int _minTurn;
  late int _maxTurn;

  Future<void> init(NumberProvider numberProvider) async {
    if (_configList.isNotEmpty) {
      return;
    }

    _minTurn = numberProvider.minTurn;
    _maxTurn = numberProvider.maxTurn;

    _configList = await _configDB.get();

    notifyListeners();

    if (_configList.isNotEmpty) {
      numberProvider.sortCountList(
        minTurn: getValue(ConfigKind.minTurn),
        maxTurn: getValue(ConfigKind.maxTurn),
      );
      return;
    }

    for (var e in ConfigKind.values) {
      ConfigModel configModel;

      if (ConfigKind.minTurn == e) {
        configModel = ConfigModel(id: e.index, value: _minTurn);
      } else if (ConfigKind.maxTurn == e) {
        configModel = ConfigModel(id: e.index, value: _maxTurn);
      } else {
        configModel = ConfigModel(id: e.index, value: 0);
      }

      _configList.add(configModel);
      _configDB.insert(configModel);
    }

    numberProvider.sortCountList(
      minTurn: getValue(ConfigKind.minTurn),
      maxTurn: getValue(ConfigKind.maxTurn),
    );
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

  void setTurn({required int recentTurnGap}) {
    setValue(ConfigKind.minTurn, _maxTurn - recentTurnGap);
    setValue(ConfigKind.maxTurn, _maxTurn);
  }
}
