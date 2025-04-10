import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dividerbottomsheetboardgamedetail extends StatelessWidget {
  final double height;
  final Color color;

  const Dividerbottomsheetboardgamedetail(
      {super.key, required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
        ),
        Divider(color: color),
        SizedBox(height: height),
      ],
    );
  }
}
