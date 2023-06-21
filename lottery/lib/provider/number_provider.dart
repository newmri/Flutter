import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottery/model/lottery_turn_model.dart';
import 'package:lottery/repository/lottery_repository.dart';

int numberMaxLen = 6;
int numberMax = 45;

class NumberProvider extends ChangeNotifier {

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

  late List<LotteryTurnModel> modelList;

  Future<void> init() async {
    try{
      modelList = await LotteryRepository.getModelList();
    }
    catch(e){
      print(e);
    }

    notifyListeners();

    maxTurn = modelList.length;

    for(int i = 1; i <= modelList.length; ++i) {
      _turnList.add(DropdownMenuItem(value: i, child: Text(i.toString())));
    }
  }
  
  final List<DropdownMenuItem> _turnList = [];

  List<DropdownMenuItem> get turnList{
    return _turnList;
  }

  int _minTurn = 1;
  int _maxTurn = 1;

  int get minTurn {
    return _minTurn;
  }

  set minTurn(int value) {
    _minTurn = value;
    notifyListeners();
  }

  int get maxTurn {
    return _maxTurn;
  }

  set maxTurn(int value) {
    _maxTurn = value;
    notifyListeners();
  }

  final List<List<int>> _numberList = [];

  List<List<int>> get numberList {
    return _numberList;
  }

  void generateNumber({required bool overGenerate, int count = 1}) {

    int remainedCount = numberListMaxLen - numberList.length;

    if(0 >= remainedCount) {
      if(false == overGenerate) {
        return;
      }

      for(int i = 0; i < count; ++i) {
        _numberList.removeAt(0);
      }

      remainedCount = numberListMaxLen - numberList.length;
    }

    count = min(count, remainedCount);

    for(int i = 0; i < count; ++i) {
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

  void clearNumber(){
    _numberList.clear();

    notifyListeners();
  }
}
