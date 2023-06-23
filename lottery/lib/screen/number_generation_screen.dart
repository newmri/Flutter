import 'package:flutter/material.dart';
import 'package:lottery/provider/number_provider.dart';
import 'package:lottery/provider/number_config_provider.dart';
import 'package:provider/provider.dart';
import '../component/number_list_container.dart';

class NumberGenerationScreen extends StatefulWidget {
  const NumberGenerationScreen({Key? key}) : super(key: key);

  @override
  State<NumberGenerationScreen> createState() => _NumberGenerationScreenState();
}

class _NumberGenerationScreenState extends State<NumberGenerationScreen>
    with AutomaticKeepAliveClientMixin {
  late NumberConfigProvider numberConfigProvider;
  late NumberProvider numberProvider;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    numberProvider = Provider.of<NumberProvider>(context);
    numberConfigProvider = Provider.of<NumberConfigProvider>(context);

    bool isOnLoading = numberProvider.isOnLoading();

    if(false == isOnLoading && numberConfigProvider.isOnLoading()){
      isOnLoading = true;
      numberConfigProvider.init(numberProvider.minTurn, numberProvider.maxTurn);
    }

    return Scaffold(
      body: isOnLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
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
                      value: (1 ==
                          numberConfigProvider
                              .getValue(ConfigKind.overGenerate)),
                      onChanged: (value) {
                        numberConfigProvider.setValue(
                            ConfigKind.overGenerate, value ? 1 : 0);
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
                      value: (1 ==
                          numberConfigProvider.getValue(ConfigKind.statics)),
                      onChanged: (value) {
                        numberConfigProvider.setValue(
                            ConfigKind.statics, value ? 1 : 0);
                      },
                    ),
                  ],
                ),
                (1 == numberConfigProvider.getValue(ConfigKind.statics))
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
                            value: numberConfigProvider.getValue(ConfigKind.minTurn),
                            items: numberProvider.turnList,
                            onChanged: (value) {
                              numberConfigProvider.setValue(ConfigKind.minTurn, value as int);
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
                            value: numberConfigProvider.getValue(ConfigKind.maxTurn),
                            items: numberProvider.turnList,
                            onChanged: (value) {
                              numberConfigProvider.setValue(ConfigKind.maxTurn, value as int);
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
                            numberProvider.generateNumber(
                                overGenerate: (1 ==
                                    numberConfigProvider
                                        .getValue(ConfigKind.overGenerate)));
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              //side: BorderSide(color: Colors.red) // border line color
                            )),
                          ),
                          child: const Text("번호 1개 생성"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            numberProvider.generateNumber(
                              overGenerate: (1 ==
                                  numberConfigProvider
                                      .getValue(ConfigKind.overGenerate)),
                              count: 5,
                            );
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
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
