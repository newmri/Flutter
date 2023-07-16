import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery/provider/number_provider.dart';
import 'package:lottery/provider/number_config_provider.dart';
import 'package:provider/provider.dart';
import '../component/number_list_container.dart';
import '../component/statics_widget.dart';

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

  final TextEditingController _staticsMinTurnController =
      TextEditingController();
  final TextEditingController _staticsMaxTurnController =
      TextEditingController();

  final StaticsWidget staticsWidget = StaticsWidget();

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
                        renderNumbers(),
                      ],
                    ),
                  ),
                ),
                renderBottom(),
              ],
            ),
    );
  }

  Container renderNumbers() {
    return numberProvider.numberLen > 0
        ? Container(
            margin: const EdgeInsets.only(
                left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
            padding: const EdgeInsets.only(
              left: 0.0,
              top: 0.0,
              bottom: 0.0,
              right: 0.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: NumberListContainer(),
          )
        : Container();
  }

  Widget renderBottom() {
    return Column(
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
              value:
                  (1 == numberConfigProvider.getValue(ConfigKind.overGenerate)),
              onChanged: (value) {
                numberConfigProvider.setValue(
                    ConfigKind.overGenerate, value ? 1 : 0);
              },
            ),
          ],
        ),
        staticsWidget,
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: generationButtonSize,
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

                    numberProvider.generateNumber(
                      overGenerate: (1 ==
                          numberConfigProvider
                              .getValue(ConfigKind.overGenerate)),
                      count: 1,
                      staticsTop: numberConfigProvider.getStaticsTop(),
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
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue[300]),
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

                    numberProvider.generateNumber(
                      overGenerate: (1 ==
                          numberConfigProvider
                              .getValue(ConfigKind.overGenerate)),
                      count: 5,
                      staticsTop: numberConfigProvider.getStaticsTop(),
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
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(Colors.red[400]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
    );
  }
}
