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

    return LotteryTurnModel(id: json['turn'], value: value);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': value,
    };
  }
}
