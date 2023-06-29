import 'package:flutter/material.dart';
import 'package:lottery/screen/root_screen.dart';
import 'package:lottery/const/colors.dart';
import 'package:lottery/model/BottomNavigationBarModel.dart';
import 'package:lottery/screen/number_generation_screen.dart';
import 'package:lottery/screen/purchase_simulation_screen.dart';
import 'package:lottery/screen/qr_code_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottery/provider/number_config_provider.dart';
import 'package:lottery/provider/number_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();

  var numberProvider = NumberProvider();
  numberProvider.init();

  var numberConfigProvider = NumberConfigProvider();

  List<BottomNavigationBarModel> itemList = [
    BottomNavigationBarModel(
      bar: const BottomNavigationBarItem(
          icon: Icon(
            Icons.games_outlined,
          ),
          label: '번호 생성'),
      widget: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return numberProvider;
          }),
          ChangeNotifierProvider(create: (context) {
            return numberConfigProvider;
          }),
        ],
        child: const NumberGenerationScreen(),
      ),
    ),
    BottomNavigationBarModel(
      bar: const BottomNavigationBarItem(
          icon: Icon(
            Icons.shop_outlined,
          ),
          label: '가상 구매'),
      widget: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return numberProvider;
          }),
          ChangeNotifierProvider(create: (context) {
            return numberConfigProvider;
          }),
        ],
        child: const PurchaseSimulationScreen(),
      ),
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
