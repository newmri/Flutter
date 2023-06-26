import 'package:flutter/material.dart';
import 'package:lottery/component/number_list_widget.dart';
import 'package:provider/provider.dart';

import '../provider/number_provider.dart';

class NumberListContainer extends StatelessWidget {
  late NumberProvider numberProvider;

  NumberListContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    numberProvider = Provider.of<NumberProvider>(context);
    List<NumberListWidget> numberListWidget = [];

    for (int i = 0; i < numberProvider.numberList.length; ++i) {
      numberListWidget.add(
        NumberListWidget(
          numberList: numberProvider.numberList[i],
          count: i + 1,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numberListWidget,
    );
  }
}
