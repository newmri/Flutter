import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottery/model/lottery_turn_model.dart';
import 'package:lottery/repository/lottery_repository.dart';
import 'package:lottery/database/turn_db.dart';
import 'package:lottery/model/simple_turn_model.dart';

int numberMaxLen = 6;
int numberMax = 45;

class NumberProvider extends ChangeNotifier {
  final TurnDB _turnDB = TurnDB();

  int get numberLen {
    return _numberList.length;
  }

  int get numberListMaxLen {
    return 5;
  }

  double get numberWidth {
    return 50.0;
  }

  double get numberHeight {
    return 50.0;
  }

  late List<LotteryTurnModel> _turnModelList = [];

  Future<void> init() async {
    try {
      _turnModelList = await _turnDB.get();

      var newTurnModelList = await LotteryRepository.getModelList(minTurn: _turnModelList.length);

      if (newTurnModelList.isNotEmpty) {
        for (var element in newTurnModelList) {
          _turnDB.insert(element);
        }

        _turnModelList.addAll(newTurnModelList);
      }
    } catch (e) {
      print(e);
    }

    notifyListeners();

    for (int i = 1; i <= _turnModelList.length; ++i) {
      _turnList.add(DropdownMenuItem(value: i, child: Text(i.toString())));
    }
  }

  final List<DropdownMenuItem> _turnList = [];

  bool isOnLoading() {
    return _turnList.isEmpty;
  }

  int get minTurn {
    return 1;
  }

  int get maxTurn {
    return isOnLoading() ? 1 : _turnModelList.last.id;
  }

  List<DropdownMenuItem> get turnList {
    return _turnList;
  }

  final List<List<int>> _numberList = [];

  List<List<int>> get numberList {
    return _numberList;
  }

  void generateNumber(
      {required bool overGenerate,
      required int count,
      required SimpleTurnModel? turnModel}) {
    int remainedCount = numberListMaxLen - numberList.length;

    if (0 >= remainedCount) {
      if (false == overGenerate) {
        return;
      }

      for (int i = 0; i < count; ++i) {
        _numberList.removeAt(0);
      }

      remainedCount = numberListMaxLen - numberList.length;
    }

    count = min(count, remainedCount);

    for (int i = 0; i < count; ++i) {
      List<int> newNumberList = [];

      while (true) {
        var number = Random().nextInt(numberMax) + 1;

        if (!newNumberList.contains(number)) {
          newNumberList.add(number);
        }

        if (newNumberList.length == numberMaxLen) {
          break;
        }
      }

      newNumberList.sort();

      _numberList.add(newNumberList);
    }

    notifyListeners();
  }

  void clearNumber() {
    _numberList.clear();

    notifyListeners();
  }
}
