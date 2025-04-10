import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';

class ButtonCommonFilter extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const ButtonCommonFilter({
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
            EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
        minimumSize: MaterialStateProperty.all(Size(0, 0)),
        foregroundColor:
            MaterialStateProperty.all(isSelected ? mainGold : mainGrey),
        side: MaterialStateProperty.all(
          BorderSide(color: isSelected ? mainGold : mainGrey),
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
