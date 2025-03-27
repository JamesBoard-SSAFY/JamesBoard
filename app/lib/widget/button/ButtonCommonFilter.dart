import 'package:flutter/material.dart';

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
        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
        foregroundColor: MaterialStateProperty.all(
            isSelected ? Colors.yellow : Colors.white),
        side: MaterialStateProperty.all(
          BorderSide(color: isSelected ? Colors.yellow : Colors.white),
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
          fontFamily: 'PretendardMedium',
        ),
      ),
    );
  }
}
