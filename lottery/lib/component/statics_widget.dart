import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/number_config_provider.dart';
import '../provider/number_provider.dart';

class StaticsWidget extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();

  StaticsWidget({Key? key}) : super(key: key);

  @override
  State<StaticsWidget> createState() => _StaticsWidgetState(formKey: _formKey);

  bool isValidate(){
    return _formKey.currentState!.validate();
  }

  void save(){
    _formKey.currentState!.save();
  }
}

class _StaticsWidgetState extends State<StaticsWidget> {
  late GlobalKey<FormState> formKey;
  
  
  late NumberConfigProvider numberConfigProvider;
  late NumberProvider numberProvider;

  final TextEditingController _staticsMinTurnController =
      TextEditingController();
  final TextEditingController _staticsMaxTurnController =
      TextEditingController();

  final TextEditingController _staticsTopController = TextEditingController();

  _StaticsWidgetState({required this.formKey});

  void init() {
    var staticsTop = numberConfigProvider.getValue(ConfigKind.staticsTop);
    if (0 != staticsTop) {
      final text = staticsTop.toString();

      final selection = TextSelection.collapsed(
        offset: text.length,
      );

      _staticsTopController.value = TextEditingValue(
        text: text,
        selection: selection,
      );
    }
  }

  @override
  void dispose() {
    _staticsTopController.dispose();
    _staticsMaxTurnController.dispose();
    _staticsMinTurnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    numberConfigProvider = Provider.of<NumberConfigProvider>(context);
    numberProvider = Provider.of<NumberProvider>(context);

    init();

    return Column(
      children: [
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
              value: (1 == numberConfigProvider.getValue(ConfigKind.statics)),
              onChanged: (value) {
                numberConfigProvider.setValue(
                    ConfigKind.statics, value ? 1 : 0);
              },
            ),
          ],
        ),
        (1 == numberConfigProvider.getValue(ConfigKind.statics))
            ? Column(
                children: [
                  renderTurn(),
                  Form(
                    key: formKey,
                    child: renderStaticsTop(),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  Row renderTurn() {
    return Row(
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
            value: numberConfigProvider.getValue(ConfigKind.minTurn),
            items: numberProvider.turnList,
            onChanged: (value) {
              numberConfigProvider.setValue(ConfigKind.minTurn, value as int);

              numberProvider.sortCountList(
                minTurn: numberConfigProvider.getValue(ConfigKind.minTurn),
                maxTurn: numberConfigProvider.getValue(ConfigKind.maxTurn),
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
                return item.value.toString().contains(searchValue);
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
            value: numberConfigProvider.getValue(ConfigKind.maxTurn),
            items: numberProvider.turnList,
            onChanged: (value) {
              numberConfigProvider.setValue(ConfigKind.maxTurn, value as int);

              numberProvider.sortCountList(
                minTurn: numberConfigProvider.getValue(ConfigKind.minTurn),
                maxTurn: numberConfigProvider.getValue(ConfigKind.maxTurn),
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
                return item.value.toString().contains(searchValue);
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
              minTurn: numberConfigProvider.getValue(ConfigKind.minTurn),
              maxTurn: numberConfigProvider.getValue(ConfigKind.maxTurn),
            );
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
              minTurn: numberConfigProvider.getValue(ConfigKind.minTurn),
              maxTurn: numberConfigProvider.getValue(ConfigKind.maxTurn),
            );
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
          ),
          child: const Text("일년"),
        ),
      ],
    );
  }

  Widget renderStaticsTop() {
    return TextFormField(
        controller: _staticsTopController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
            border: InputBorder.none,
            label: Text('반영할 번호 당첨 횟수 순위'),
            hintText: '$numberMaxLen ~ $numberMax'),
        validator: (value) {
          if (value!.isEmpty) {
            return '값을 입력 해야 합니다.';
          }

          var top = int.tryParse(value);
          if (null == top) {
            return '유효 하지 않는 값 입니다.';
          }

          if (top != top.clamp(numberMaxLen, numberMax)) {
            return '$numberMaxLen ~ $numberMax 사이의 숫자를 입력 하세요.';
          }
        },
        onSaved: (value) {
          var top = int.tryParse(value!);
          if (null == top) {
            return;
          }

          numberConfigProvider.setValue(
              ConfigKind.staticsTop, top);

          numberConfigProvider.setValue(ConfigKind.staticsTop, top);
        });
  }


}
