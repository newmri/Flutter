import 'package:flutter/material.dart';
import 'package:lottery/component/number_widget.dart';

class NumberGenerationScreen extends StatelessWidget {
  static const double numberWidth = 50.0;
  static const double numberHeight = 50.0;
  static int currNumber = 0;

  const NumberGenerationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    currNumber = 0;

    List<int> numberList = [8, 10, 45, 1, 6, 4];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          renderNumbers(numberList),
          renderNumbers(numberList),
          renderNumbers(numberList),
          renderNumbers(numberList),
          renderNumbers(numberList),
          ElevatedButton(
            onPressed: () {},
            child: const Text("번호 생성"),
          ),
        ],
      ),
    );
  }

  Row renderNumbers(List<int> numberList) {
    ++currNumber;

    List<Widget> itemList = [];

    itemList.add(
      Text(
        style: const TextStyle(
          fontSize: 25,
          letterSpacing: 1
        ),
        "$currNumber. ",

      ),
    );

    itemList.addAll(numberList
        .map((number) => SizedBox(
              width: numberWidth,
              height: numberHeight,
              child: NumberWidget(number: number),
            ))
        .toList());

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: itemList);
  }
}
