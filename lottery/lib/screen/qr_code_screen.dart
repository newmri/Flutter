import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        renderScanner(),
        renderText(),
      ],
    ));
  }

  MobileScanner renderScanner() {
    return MobileScanner(
      fit: BoxFit.cover,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          if (BarcodeType.url != barcode.type) {
            renderErrorToast();
            return;
          }

          String url = barcode.rawValue!;
          if (false == url.contains("lottery.co.kr/")) {
            renderErrorToast();
            return;
          }

          setState(() {
            openUrl(url);
            return;
          });
        }
      },
    );
  }

  Align renderText() {
    return const Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: 50,
        child: Text(
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            "QR 코드를 스캔 해주세요."),
      ),
    );
  }

  void renderErrorToast() {
    Fluttertoast.showToast(
      msg: "잘못된 QR 코드 입니다.",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  openUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
