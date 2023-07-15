import 'package:flutter/material.dart';

class NumberWidget extends StatelessWidget {

  final int number;
  late final Color color;

  NumberWidget({required this.number, Key? key}) : super(key: key) {
    if (1 <= number && 10 >= number) {
      color = const Color(0xFFFBC400);
    } else if (11 <= number && 20 >= number) {
      color = const Color(0xFF69C8F2);
    } else if (21 <= number && 30 >= number) {
      color = const Color(0xFFFF7272);
    } else if (31 <= number && 40 >= number) {
      color = Colors.grey;
    } else {
      color = const Color(0xFFB0D840);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CircleAvatar(
          backgroundColor: color,
          child: Text(
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFFFFF5CB),
              ),
              number.toString()),
        ),
      ),
    );
  }
}
