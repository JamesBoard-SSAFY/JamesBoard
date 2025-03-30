import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';

class ButtonSurveyBoardGameName extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const ButtonSurveyBoardGameName({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.all(10),
        ),
        foregroundColor: MaterialStateProperty.all(
          isSelected ? mainGold : mainWhite,
        ),
        side: MaterialStateProperty.all(
          BorderSide(
            color: isSelected ? mainGold : mainWhite,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontFamily: FontString.pretendardMedium,
        ),
      ),
    );
  }
}
