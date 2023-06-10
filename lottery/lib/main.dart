import 'package:flutter/material.dart';
import 'package:lottery/screen/root_screen.dart';
import 'package:lottery/const/colors.dart';
import 'package:lottery/model/BottomNavigationBarModel.dart';
import 'package:lottery/screen/number_generation_screen.dart';
import 'package:lottery/screen/store_screen.dart';
import 'package:lottery/screen/qr_code_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();

  List<BottomNavigationBarModel> itemList = [
    BottomNavigationBarModel(
      bar: const BottomNavigationBarItem(
          icon: Icon(
            Icons.games_outlined,
          ),
          label: '번호 생성'),
      widget: const NumberGenerationScreen(),
    ),
    BottomNavigationBarModel(
      bar: const BottomNavigationBarItem(
          icon: Icon(
            Icons.map_outlined,
          ),
          label: '주변 판매점 찾기'),
      widget: const StoreScreen(),
    ),
    BottomNavigationBarModel(
      bar: const BottomNavigationBarItem(
          icon: Icon(
            Icons.qr_code_outlined,
          ),
          label: 'QR 코드 확인'),
      widget: const QRCodeScreen(),
    ),
  ];

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
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
