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

  void generateNumber() {
    if(numberListMaxLen <= numberList.length) {
      return;
    }

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

    _numberList.add(newNumberList);

    notifyListeners();
  }
}
