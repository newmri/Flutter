import 'package:lottery/model/lottery_model.dart';

class LotteryTurnModel {
  int id;
  LotteryModel value;

  LotteryTurnModel({required this.id, required this.value});

  factory LotteryTurnModel.fromMap(Map<String, dynamic> json) => LotteryTurnModel(
    id: json['id'],
    value: json['value'],
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'value': value,
    };
  }
}
