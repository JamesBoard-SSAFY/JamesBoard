import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';

class ButtonCommonGameTag extends StatelessWidget {
  final String text;
  const ButtonCommonGameTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: secondaryBlack, // 배경색
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: mainGold,
          fontSize: 16,
          fontFamily: FontString.pretendardMedium,
          backgroundColor: secondaryBlack,
        ),
      ),
    );
  }
}
