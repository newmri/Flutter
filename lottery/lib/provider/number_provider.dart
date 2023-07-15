import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottery/model/lottery_turn_model.dart';
import 'package:lottery/repository/lottery_repository.dart';
import 'package:lottery/database/turn_db.dart';
import 'package:lottery/model/number_count_model.dart';

import 'number_config_provider.dart';

int numberMaxLen = 6;
int numberMax = 45;
int rankMax = 6;

class NumberProvider extends ChangeNotifier {
  final TurnDB _turnDB = TurnDB();

  int get numberLen {
    return _numberList.length;
  }

  int get numberListMaxLen {
    return 5;
  }

  double get numberWidth {
    return 45.0;
  }

  double get numberHeight {
    return 55.0;
  }

  late List<LotteryTurnModel> _turnModelList = [];

  Future<void> init() async {
    try {
      _turnModelList = await _turnDB.get();

      var newTurnModelList =
          await LotteryRepository.getModelList(minTurn: _turnModelList.length);

      if (newTurnModelList.isNotEmpty) {
        for (var element in newTurnModelList) {
          _turnDB.insert(element);
        }

        _turnModelList.addAll(newTurnModelList);
      }
    } catch (e) {
      _renderErrorToast("인터넷 상태를 확인 해 주세요.");
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
      required bool useStatics}) {
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
      List<int> newNumberList = _generateNumbers(useStatics: useStatics);
      newNumberList.sort();

      _numberList.add(newNumberList);
    }

    notifyListeners();
  }

  final List<NumberCountModel> _countList =
      List.generate(numberMax, (index) => NumberCountModel(number: index + 1));

  void sortCountList({required int minTurn, required int maxTurn}) {

    for(int i = 0; i < numberMax; ++i){
      _countList[i].number = i+1;
      _countList[i].count = 0;
    }

    for (int i = minTurn; i <= maxTurn; ++i) {
      for (int j = 0; j < numberMaxLen; ++j) {
        int index = (_turnModelList[i - 1].value.numberList[j]) - 1;
        ++_countList[index].count;
      }
    }

    _countList.sort((a, b) => b.count.compareTo(a.count));
  }

  final int staticsTop = 10;

  List<int> _generateNumbers({required bool useStatics}){
    List<int> numberList = [];

    while (true) {
      var number = _generateNumber(useStatics: useStatics);

      if (!numberList.contains(number)) {
        numberList.add(number);
      }

      if (numberList.length == numberMaxLen) {
        break;
      }
    }

    return numberList;
  }

  int _generateNumber({required bool useStatics}) {
    int number = 0;

    if (useStatics) {
      number = _countList[Random().nextInt(staticsTop)].number;
    } else {
      number = Random().nextInt(numberMax) + 1;
    }

    return number;
  }

  void clearNumber() {
    _numberList.clear();

    notifyListeners();
  }

  List<String> _purchaseResult = [];

  int get purchaseResultLen {
    return _purchaseResult.length;
  }

  List<String> get purchaseResult {
    return _purchaseResult;
  }

  void purchase(NumberConfigProvider numberConfigProvider) {
    final purchaseCount =
    numberConfigProvider.getValue(ConfigKind.purchaseCount);
    if (0 == purchaseCount) {
      _renderErrorToast("구매 횟수를 정해 주세요.");
      return;
    }

    final turnIndex = numberConfigProvider.getValue(ConfigKind.purchaseTurn) - 1;

    final useStatics = (1 == numberConfigProvider.getValue(ConfigKind.statics));

    List<int> rankCount = List.filled(rankMax, 0);

    _purchaseResult.clear();

    for (var i = 0; i < purchaseCount; ++i) {
      List<int> newNumberList = _generateNumbers(useStatics: useStatics);
      newNumberList.sort();

      int sameNumberCount = 0;
      bool isSameBonus = false;

      for(var j = 0; j < numberMaxLen; ++j){
        if(newNumberList[j] == _turnModelList[turnIndex].value.numberList[j]){
          ++sameNumberCount;
        }
        else if(newNumberList[j] == _turnModelList[turnIndex].value.numberList[numberMaxLen]){
          isSameBonus = true;
        }
      }

      int rank = _getRank(sameNumberCount, isSameBonus);
      rankCount[rank - 1] += 1;
    }

    for(int i = 0; i < rankCount.length; ++i){
      var ratio = (rankCount[i] / purchaseCount) * 100;
      _purchaseResult.add("${i+1}등: ${rankCount[i]} (${ratio.toStringAsFixed(2)}%)");
    }

    notifyListeners();
  }

  int _getRank(int sameNumberCount, bool isSameBonus){
    int rank = 0;

    switch(sameNumberCount){
      case 6:
        rank = 1;
        break;
      case 5:
        if(isSameBonus){
          rank = 2;
        }
        else{
          rank = 3;
        }
        break;
      case 4:
        rank = 4;
        break;
      case 3:
        rank = 5;
        break;
      default:
        rank = 6;
        break;
    }

    return rank;
  }

  void _renderErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
