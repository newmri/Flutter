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
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NumberListContainer(),
            ElevatedButton(
              onPressed: () {
                numberProvider.generateNumber();
              },
              child: const Text("번호 생성"),
            ),
          ],
        ),
      );
  }
}
