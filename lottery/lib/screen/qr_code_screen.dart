import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

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
      fit: BoxFit.contain,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          if (BarcodeType.url != barcode.type) {
            return;
          }

          String url = barcode.rawValue!;

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
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 70,
        child: Text("QRCode를 스캔 해주세요."),
      ),
    );
  }

  openUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
