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
          numberProvider.numberLen > 0 ? Container(
            margin: const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 10.0),
            padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0,),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: NumberListContainer(),
          ) : Container()
          ,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
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
        ],
      ),
    );
  }
}
