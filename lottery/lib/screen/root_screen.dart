import 'package:flutter/material.dart';
import 'package:lottery/screen/home_screen.dart';
import 'package:lottery/model/BottomNavigationBarModel.dart';

class RootScreen extends StatefulWidget {
  late List<BottomNavigationBarModel> itemList;

  RootScreen({required this.itemList, Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState(itemList: itemList);
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  late List<BottomNavigationBarModel> itemList;

  late TabController controller;

  _RootScreenState({required this.itemList});

  @override
  void initState() {
    super.initState();

    controller =
        TabController(length: itemList.length, vsync: this);

    controller.addListener(tabListener);
  }

  tabListener() {
    setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TabBarView(
          controller: controller,
          children: itemList.map((e) => e.widget).toList(),
        ),
      ),
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
        currentIndex: controller.index,
        onTap: (int index) {
          setState(() {
            controller.animateTo(index);
          });
        },
        items: itemList.map((e) => e.bar).toList());
  }
}
