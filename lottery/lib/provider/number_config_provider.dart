import 'package:flutter/cupertino.dart';
import 'package:lottery/model/config_model.dart';

enum ConfigKind {
  statics,
  overGenerate,
}

class NumberConfigProvider extends ChangeNotifier {
  final List<ConfigModel> _configList = [];

  Future<void> init() async {
    for (var e in ConfigKind.values) {
      _configList.add(ConfigModel(id: e.index, value: 0));
    }
  }

  int getValue(ConfigKind kind) {
    return _configList[kind.index].value;
  }

  void setValue(ConfigKind kind, int value) {
    _configList[kind.index].value = value;
    notifyListeners();
  }
}
