import 'package:flutter/material.dart';
import 'package:lottery/provider/number_provider.dart';
import 'package:provider/provider.dart';

import '../component/number_list_container.dart';

class NumberGenerationScreen extends StatelessWidget {
  late NumberProvider numberProvider;

  NumberGenerationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    numberProvider = Provider.of<NumberProvider>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                style: TextStyle(
                  fontSize: 20,
                ),
                '번호 덮어서 생성',
              ),
              Switch(
                value: numberProvider.getUse(UseKind.overGenerate),
                onChanged: (value) {
                  numberProvider.setUse(UseKind.overGenerate, value);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                style: TextStyle(
                  fontSize: 20,
                ),
                '통계 사용',
              ),
              Switch(
                value: numberProvider.getUse(UseKind.statics),
                onChanged: (value) {
                  numberProvider.setUse(UseKind.statics, value);
                },
              ),
            ],
          ),
          numberProvider.getUse(UseKind.statics)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      '회차 선택',
                    ),
                    Container(
                      width: 15,
                    ),
                    DropdownButton(
                      value: numberProvider.minTurn,
                      items: numberProvider.turnList,
                      onChanged: (value) {
                        numberProvider.minTurn = value as int;
                      },
                    ),
                    Container(
                      width: 15,
                    ),
                    const SizedBox(
                      width: 30,
                      child: Text("~"),
                    ),
                    DropdownButton(
                      value: numberProvider.maxTurn,
                      items: numberProvider.turnList,
                      onChanged: (value) {
                        numberProvider.maxTurn = value as int;
                      },
                    ),
                  ],
                )
              : Container(),
          numberProvider.numberLen > 0
              ? Container(
                  margin: const EdgeInsets.only(
                      left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    top: 10.0,
                    right: 10.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: NumberListContainer(),
                )
              : Container(),
          Expanded(
            child: SizedBox(
              height: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      numberProvider.generateNumber();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        //side: BorderSide(color: Colors.red) // border line color
                      )),
                    ),
                    child: const Text("번호 1개 생성"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      numberProvider.generateNumber(count: 5);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        //side: BorderSide(color: Colors.red) // border line color
                      )),
                    ),
                    child: const Text("번호 5개 생성"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      numberProvider.clearNumber();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        //side: BorderSide(color: Colors.red) // border line color
                      )),
                    ),
                    child: const Text("번호 초기화"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
