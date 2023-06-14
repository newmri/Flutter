import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NumberProvider extends ChangeNotifier {
  int get numberMaxLen {
    return 6;
  }

  int get numberMax {
    return 45;
  }

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

  final List<List<int>> _numberList = [];

  List<List<int>> get numberList {
    return _numberList;
  }

  void generateNumber({int count = 1}) {

    int remainedCount = numberListMaxLen - numberList.length;

    if(0 >= remainedCount) {
      return;
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
