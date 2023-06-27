import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery/provider/number_config_provider.dart';
import 'package:provider/provider.dart';

class PurchaseSimulationScreen extends StatefulWidget {
  const PurchaseSimulationScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseSimulationScreen> createState() => _PurchaseSimulationScreenState();
}

class _PurchaseSimulationScreenState extends State<PurchaseSimulationScreen>
  with AutomaticKeepAliveClientMixin {
  late NumberConfigProvider numberConfigProvider;

  static const _minPurchaseCount = 1;
  static const _maxPurchaseCount = 1000000;
  final TextEditingController _purchaseCountController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    numberConfigProvider = Provider.of<NumberConfigProvider>(context);

    bool isOnLoading = numberConfigProvider.isOnLoading();

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
          TextFormField(
            controller: _purchaseCountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              label: Text('구매 횟수'),
              hintText: '$_minPurchaseCount ~ $_maxPurchaseCount'
            ),
            onChanged: (String value) {
              final purchaseCount = int.tryParse(value);
              if (null != purchaseCount) {
                final text = purchaseCount.clamp(_minPurchaseCount, _maxPurchaseCount).toString();
                final selection = TextSelection.collapsed(
                  offset: text.length,
                );
                _purchaseCountController.value = TextEditingValue(
                  text: text,
                  selection: selection,
                );
              }
            },
          ),
        ],
      ),
    );

  }
}
