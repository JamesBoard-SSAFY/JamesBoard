import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

class ButtonCommonGameTag extends StatelessWidget {
  final String text;
  const ButtonCommonGameTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: secondaryBlack, // 배경색
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: mainGold,
          fontSize: 16,
          fontFamily: 'PretendardSemiBold',
          backgroundColor: secondaryBlack,
        ),
      ),
    );
  }
}