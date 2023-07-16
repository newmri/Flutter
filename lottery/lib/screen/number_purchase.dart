import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery/component/statics_widget.dart';
import 'package:lottery/provider/number_config_provider.dart';
import 'package:provider/provider.dart';

import '../component/number_purchase_container.dart';
import '../provider/number_provider.dart';

class NumberPurchaseScreen extends StatefulWidget {
  const NumberPurchaseScreen({Key? key}) : super(key: key);

  @override
  State<NumberPurchaseScreen> createState() => _NumberPurchaseScreenState();
}

class _NumberPurchaseScreenState extends State<NumberPurchaseScreen>
    with AutomaticKeepAliveClientMixin {
  var _isInitialized = false;

  late NumberConfigProvider numberConfigProvider;
  late NumberProvider numberProvider;

  static const _minPurchaseCount = 1;
  static const _maxPurchaseCount = 1000000;
  final TextEditingController _purchaseCountController =
      TextEditingController();

  final TextEditingController _purchaseTurnController = TextEditingController();

  final StaticsWidget staticsWidget = StaticsWidget();

  static const buttonSize = 50.0;
  static const double buttonFontSize = 17.0;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
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
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      children: [
                        // Content widgets
                        Container(height: 20),
                        renderResult(),
                      ],
                    ),
                  ),
                ),
                renderBottom(),
              ],
            ),
    );
  }

  Container renderResult() {
    return numberProvider.purchaseResultLen > 0
        ? Container(
            margin: const EdgeInsets.only(
                left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
            padding: const EdgeInsets.only(
              left: 10.0,
              top: 0.0,
              bottom: 0.0,
              right: 100.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: NumberPurchaseResultContainer(),
          )
        : Container();
  }

  Widget renderBottom() {
    return Column(
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
              border: InputBorder.none,
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
                value: numberConfigProvider.getValue(ConfigKind.purchaseTurn),
                items: numberProvider.turnList,
                onChanged: (value) {
                  numberConfigProvider.setValue(ConfigKind.purchaseTurn, value);
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
        staticsWidget,
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: buttonSize,
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue[200]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    if (!staticsWidget.isValidate()) {
                      return;
                    }

                    staticsWidget.save();

                    numberProvider.purchase(
                      numberConfigProvider,
                    );
                  },
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
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.green[300]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
    );
  }
}
