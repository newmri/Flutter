import 'package:flutter/material.dart';
import 'package:lottery/component/number_widget.dart';
import 'package:provider/provider.dart';

import '../provider/number_provider.dart';

class NumberListWidget extends StatelessWidget {
  late NumberProvider numberProvider;
  late List<int> numberList;
  final int count;

  NumberListWidget({required this.numberList, this.count = 0, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    numberProvider = Provider.of<NumberProvider>(context);

    List<Widget> itemList = [];

    if(0 != count) {
      itemList.add(
        Text(
          style: const TextStyle(fontSize: 30, letterSpacing: 0),
          "$count.",
        ),
      );
    }

    itemList.addAll(numberList
        .map((number) =>
        SizedBox(
          width: numberProvider.numberWidth,
          height: numberProvider.numberHeight,
          child: NumberWidget(number: number),
        ))
        .toList());

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: itemList,
    );
  }
}
