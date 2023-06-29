import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery/provider/number_config_provider.dart';
import 'package:provider/provider.dart';

import '../provider/number_provider.dart';

class PurchaseSimulationScreen extends StatefulWidget {
  const PurchaseSimulationScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseSimulationScreen> createState() =>
      _PurchaseSimulationScreenState();
}

class _PurchaseSimulationScreenState extends State<PurchaseSimulationScreen>
    with AutomaticKeepAliveClientMixin {

  var _isInitialized = false;

  late NumberConfigProvider numberConfigProvider;
  late NumberProvider numberProvider;

  static const _minPurchaseCount = 1;
  static const _maxPurchaseCount = 1000000;
  final TextEditingController _purchaseCountController =
      TextEditingController();

  final TextEditingController _purchaseTurnController = TextEditingController();

  final TextEditingController _staticsMinTurnController =
      TextEditingController();
  final TextEditingController _staticsMaxTurnController =
      TextEditingController();

  static const buttonSize = 50.0;
  static const double buttonFontSize = 17.0;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _staticsMaxTurnController.dispose();
    _staticsMinTurnController.dispose();
    _purchaseTurnController.dispose();
    _purchaseCountController.dispose();
    super.dispose();
  }

  void init() {
    _isInitialized = true;

    var purchaseCount = numberConfigProvider.getValue(ConfigKind.purchaseCount);
    if (0 != purchaseCount) {
      final text = purchaseCount.toString();

      final selection = TextSelection.collapsed(
        offset: text.length,
      );

      _purchaseCountController.value = TextEditingValue(
        text: text,
        selection: selection,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    numberConfigProvider = Provider.of<NumberConfigProvider>(context);
    numberProvider = Provider.of<NumberProvider>(context);

    bool isOnLoading =
        numberConfigProvider.isOnLoading() || numberProvider.isOnLoading();

    if (false == isOnLoading && false == _isInitialized) {
      init();
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
                renderBottom(),
              ],
            ),
    );
  }

  Expanded renderBottom() {
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
            ),
            TextFormField(
              controller: _purchaseCountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                  label: Text('구매 횟수'),
                  hintText: '$_minPurchaseCount ~ $_maxPurchaseCount'),
              onChanged: (String value) {
                var purchaseCount = int.tryParse(value);
                if (null != purchaseCount) {
                  purchaseCount =
                      purchaseCount.clamp(_minPurchaseCount, _maxPurchaseCount);

                  final text = purchaseCount.toString();

                  final selection = TextSelection.collapsed(
                    offset: text.length,
                  );

                  numberConfigProvider.setValue(
                      ConfigKind.purchaseCount, purchaseCount);

                  _purchaseCountController.value = TextEditingValue(
                    text: text,
                    selection: selection,
                  );
                }
              },
            ),
            Container(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  '구매 회차',
                ),
                Container(
                  width: 10,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    value:
                        numberConfigProvider.getValue(ConfigKind.purchaseTurn),
                    items: numberProvider.turnList,
                    onChanged: (value) {
                      numberConfigProvider.setValue(
                          ConfigKind.purchaseTurn, value);
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
                      searchController: _purchaseTurnController,
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
                          controller: _purchaseTurnController,
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
                        return item.value.toString().contains(searchValue);
                      },
                    ),
                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        _purchaseTurnController.clear();
                      }
                    },
                  ),
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
                    height: buttonSize,
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
                      onPressed: () {},
                      child: const Text(
                        "구매",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: buttonFontSize,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: buttonSize,
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green[300]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "과거 기록",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: buttonFontSize,
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
