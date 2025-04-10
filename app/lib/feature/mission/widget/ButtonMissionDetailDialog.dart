import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';

class ButtonMissionDetailDialog extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonMissionDetailDialog(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool isConfirm = text == AppString.confirm;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12.5),
        decoration: BoxDecoration(
            color: isConfirm ? mainRed : Colors.transparent,
            border: Border.all(color: mainGold, width: 1),
            borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: mainGold,
            fontSize: 16,
            fontFamily: FontString.pretendardSemiBold,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
