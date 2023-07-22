import 'package:lottery/model/purchase_statics_model.dart';

import '../provider/number_provider.dart';
import 'lottery_model.dart';

class PurchaseHistoryModel {
  int turn;
  int count;
  LotteryModel rank;
  PurchaseStaticsModel statics;

  PurchaseHistoryModel({
    required this.turn,
    required this.count,
    required this.rank,
    required this.statics,
  });

  factory PurchaseHistoryModel.fromMap(Map<String, dynamic> json) {
    LotteryModel rank = LotteryModel();

    for (int i = 1; i <= rankMax; ++i) {
      rank.addNumber(json['rank_$i']);
    }

    PurchaseStaticsModel statics = PurchaseStaticsModel(
      minTurn: json['min_turn'],
      maxTurn: json['max_turn'],
      top: json['top'],
    );

    return PurchaseHistoryModel(
      turn: json['turn'],
      count: json['count'],
      rank: rank,
      statics: statics,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> mapList = {};

    mapList['turn'] = turn;
    mapList['count'] = count;

    for (int i = 1; i <= rankMax; ++i) {
      mapList['rank_$i'] = rank.numberList[i - 1];
    }

    mapList['min_turn'] = statics.minTurn;
    mapList['max_turn'] = statics.maxTurn;
    mapList['top'] = statics.top;

    return mapList;
  }
}
