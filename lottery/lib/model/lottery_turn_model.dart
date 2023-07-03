import 'package:lottery/model/lottery_model.dart';
import 'package:lottery/provider/number_provider.dart';

class LotteryTurnModel {
  int id;
  LotteryModel value;

  LotteryTurnModel({required this.id, required this.value});

  factory LotteryTurnModel.fromMap(Map<String, dynamic> json) {
    LotteryModel value = LotteryModel();

    for (int i = 1; i <= numberMaxLen; ++i) {
      value.addNumber(json['number_$i']);
    }

    value.addNumber(json['bonus']);

    return LotteryTurnModel(id: json['turn'], value: value);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> mapList = {};

    mapList['turn'] = id;

    for (int i = 1; i <= numberMaxLen; ++i) {
      mapList['number_$i'] = value.numberList[i - 1];
    }

    mapList['bonus'] = value.numberList.last;

    return mapList;
  }
}
