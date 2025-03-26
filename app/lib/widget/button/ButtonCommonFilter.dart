import 'package:flutter/material.dart';

class ButtonCommonFilter extends StatefulWidget {
  final String text;

  const ButtonCommonFilter({
    super.key,
    required this.text
  });

  @override
  _ButtonCommonFilterState createState() => _ButtonCommonFilterState();
}

class _ButtonCommonFilterState extends State<ButtonCommonFilter> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          isSelected = !isSelected; // 클릭할 때마다 상태 변경
        });
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
        foregroundColor: MaterialStateProperty.all(
            isSelected ? Colors.yellow : Colors.white),
        side: MaterialStateProperty.all(
          BorderSide(color: isSelected ? Colors.yellow : Colors.white),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), // 🔹 원하는 radius 값 적용
          ),
        ),
      ),
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'PretendardMedium',
        ),
      ),
    );
  }
}