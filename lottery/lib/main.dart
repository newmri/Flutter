import 'package:flutter/material.dart';
import 'package:lottery/screen/root_screen.dart';
import 'package:lottery/const/colors.dart';
import 'package:lottery/model/BottomNavigationBarModel.dart';
import 'package:lottery/screen/home_screen.dart';
import 'package:lottery/screen/store_screen.dart';
import 'package:lottery/screen/qr_code_screen.dart';

void main() {
  List<BottomNavigationBarModel> itemList = [
    BottomNavigationBarModel(
      bar: const BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'Home'),
      widget: const HomeScreen(),
    ),
    BottomNavigationBarModel(
      bar: const BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
          ),
          label: '주변 판매점 찾기'),
      widget: const StoreScreen(),
    ),
    BottomNavigationBarModel(
      bar: const BottomNavigationBarItem(
          icon: Icon(
            Icons.qr_code,
          ),
          label: 'QR 코드 확인'),
      widget: const QRCodeScreen(),
    ),
  ];

  runApp(
    MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
          backgroundColor: backgroundColor,
        ),
      ),
      home: RootScreen(
        itemList: itemList,
      ),
    ),
  );
}
