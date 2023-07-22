import 'package:flutter/material.dart';

import '../model/purchase_history_model.dart';

class PurchaseHistoryWidget extends StatelessWidget {
  PurchaseHistoryModel purchaseHistoryModel;

  PurchaseHistoryWidget({Key? key, required this.purchaseHistoryModel})
      : super(key: key);

  List<Text> getRenderText() {
    List<Text> resultList = [];

    resultList.add(
      Text(
        "구매 회차: ${purchaseHistoryModel.turn}",
      ),
    );

    resultList.add(
      Text(
        "통계 회차: ${purchaseHistoryModel.statics.minTurn} ~ ${purchaseHistoryModel.statics.maxTurn}",
      ),
    );

    resultList.add(
      Text(
        "반영된 상위 번호 순위: ${purchaseHistoryModel.statics.top}",
      ),
    );

    resultList.add(
      Text(
        "구매 횟수: ${purchaseHistoryModel.count}",
      ),
    );

    for (int i = 0; i < purchaseHistoryModel.rank.numberList.length; ++i) {
      var ratio = (purchaseHistoryModel.rank.numberList[i] /
              purchaseHistoryModel.count) *
          100;
      resultList.add(
        Text(
            "${i + 1}등: ${purchaseHistoryModel.rank.numberList[i]} (${ratio.toStringAsFixed(2)}%)"),
      );
    }

    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: getRenderText(),
      ),
    );
  }
}
