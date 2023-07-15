import 'package:flutter/material.dart';
import 'package:lottery/component/number_list_widget.dart';
import 'package:provider/provider.dart';

import '../provider/number_provider.dart';

class NumberPurchaseResultContainer extends StatelessWidget {
  late NumberProvider numberProvider;

  NumberPurchaseResultContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    numberProvider = Provider.of<NumberProvider>(context);

    List<Text> resultList = [];

    for (var element in numberProvider.purchaseResult) {
      resultList.add(
        Text(
          style: const TextStyle(
            fontSize: 25,
          ),
          element,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: resultList,
    );
  }
}
