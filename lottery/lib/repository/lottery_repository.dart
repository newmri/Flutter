import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottery/model/lottery_turn_model.dart';
import 'package:lottery/provider/number_provider.dart';

import '../model/lottery_model.dart';

class LotteryRepository {
  static Future<List<LotteryTurnModel>> getModelList({int minTurn = 1}) async {
    List<LotteryTurnModel> modelList = [];

    int diffDays =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .difference(DateTime(2002, 12, 07))
            .inDays;

    int maxTurn = diffDays ~/ 7 + 1;

    for (int i = minTurn; i <= maxTurn; ++i) {
      var url = Uri.parse(
          "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=$i");
      var response = await http.get(url);

      if (200 != response.statusCode) {
        throw Exception("Load Fail ErrorCode: ${response.statusCode}");
      }

      var list = jsonDecode(response.body);

      if ("success" != list["returnValue"]) {
        --maxTurn;
        break;
      }

      LotteryModel model = LotteryModel();

      for (int j = 1; j <= numberMaxLen; ++j) {
        model.addNumber(list["drwtNo$j"]);
      }

      LotteryTurnModel turnModel = LotteryTurnModel(id: i, value: model);

      modelList.add(turnModel);
    }

    return modelList;
  }
}
