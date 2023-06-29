import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  static const generationButtonSize = 50.0;
  static const double generationButtonFontSize = 17.0;

  @override
  bool get wantKeepAlive => true;

  final TextEditingController _staticsMinTurnController = TextEditingController();
  final TextEditingController _staticsMaxTurnController = TextEditingController();

  @override
  void dispose() {
    _staticsMaxTurnController.dispose();
    _staticsMinTurnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    numberConfigProvider = Provider.of<NumberConfigProvider>(context);
    numberProvider = Provider.of<NumberProvider>(context);

    bool isOnLoading = numberProvider.isOnLoading();

    if (false == isOnLoading && numberConfigProvider.isOnLoading()) {
      isOnLoading = true;
      numberConfigProvider.init(numberProvider);
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
                renderNumbers(),
                renderBottom(),
              ],
            ),
    );
  }

  Container renderNumbers() {
    return numberProvider.numberLen > 0
        ? Container(
            margin: const EdgeInsets.only(
                left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
            padding: const EdgeInsets.only(
              left: 0.0,
              top: 10.0,
              bottom: 10.0,
              right: 0.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: NumberListContainer(),
          )
        : Container();
  }

  Expanded renderBottom() {
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  '기존 번호 자동 삭제',
                ),
                Switch(
                  value: (1 ==
                      numberConfigProvider.getValue(ConfigKind.overGenerate)),
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
                  '통계',
                ),
                Switch(
                  value:
                      (1 == numberConfigProvider.getValue(ConfigKind.statics)),
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
                        '회차',
                      ),
                      Container(
                        width: 10,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          value:
                              numberConfigProvider.getValue(ConfigKind.minTurn),
                          items: numberProvider.turnList,
                          onChanged: (value) {
                            numberConfigProvider.setValue(
                                ConfigKind.minTurn, value as int);

                            numberProvider.sortCountList(
                              minTurn: numberConfigProvider
                                  .getValue(ConfigKind.minTurn),
                              maxTurn: numberConfigProvider
                                  .getValue(ConfigKind.maxTurn),
                            );
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            height: 40,
                            width: 80,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(7),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: _staticsMinTurnController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 4,
                                right: 8,
                                left: 8,
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                expands: true,
                                maxLines: null,
                                controller: _staticsMinTurnController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: '검색',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return item.value
                                  .toString()
                                  .contains(searchValue);
                            },
                          ),
                          //This to clear the search value when you close the menu
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              _staticsMinTurnController.clear();
                            }
                          },
                        ),
                      ),
                      Container(
                        width: 15,
                      ),
                      const SizedBox(
                        width: 30,
                        child: Text("~"),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          value:
                              numberConfigProvider.getValue(ConfigKind.maxTurn),
                          items: numberProvider.turnList,
                          onChanged: (value) {
                            numberConfigProvider.setValue(
                                ConfigKind.maxTurn, value as int);

                            numberProvider.sortCountList(
                              minTurn: numberConfigProvider
                                  .getValue(ConfigKind.minTurn),
                              maxTurn: numberConfigProvider
                                  .getValue(ConfigKind.maxTurn),
                            );
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            height: 40,
                            width: 80,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(7),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: _staticsMaxTurnController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 4,
                                right: 8,
                                left: 8,
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                expands: true,
                                maxLines: null,
                                controller: _staticsMaxTurnController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: '검색',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return item.value
                                  .toString()
                                  .contains(searchValue);
                            },
                          ),
                          //This to clear the search value when you close the menu
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              _staticsMaxTurnController.clear();
                            }
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          numberConfigProvider.setTurn(recentTurnGap: 4);

                          numberProvider.sortCountList(
                            minTurn: numberConfigProvider
                                .getValue(ConfigKind.minTurn),
                            maxTurn: numberConfigProvider
                                .getValue(ConfigKind.maxTurn),
                          );
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        child: const Text("한달"),
                      ),
                      Container(
                        width: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          numberConfigProvider.setTurn(recentTurnGap: 4 * 12);

                          numberProvider.sortCountList(
                            minTurn: numberConfigProvider
                                .getValue(ConfigKind.minTurn),
                            maxTurn: numberConfigProvider
                                .getValue(ConfigKind.maxTurn),
                          );
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        child: const Text("일년"),
                      ),
                    ],
                  )
                : Container(),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: generationButtonSize,
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[200]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                      onPressed: () {
                        numberProvider.generateNumber(
                          overGenerate: (1 ==
                              numberConfigProvider
                                  .getValue(ConfigKind.overGenerate)),
                          count: 1,
                          useStatics: 1 ==
                              numberConfigProvider.getValue(ConfigKind.statics),
                        );
                      },
                      child: const Text(
                        "1개 생성",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: generationButtonFontSize,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: generationButtonSize,
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[300]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                      onPressed: () {
                        numberProvider.generateNumber(
                          overGenerate: (1 ==
                              numberConfigProvider
                                  .getValue(ConfigKind.overGenerate)),
                          count: 5,
                          useStatics: 1 ==
                              numberConfigProvider.getValue(ConfigKind.statics),
                        );
                      },
                      child: const Text(
                        "5개 생성",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: generationButtonFontSize,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: generationButtonSize,
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red[400]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                      onPressed: () {
                        numberProvider.clearNumber();
                      },
                      child: const Text(
                        "초기화",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: generationButtonFontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
