import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jamesboard/theme/Colors.dart';

class TextFieldCommonGameRound extends StatelessWidget {
  final TextEditingController controller;

  const TextFieldCommonGameRound({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // 숫자만 입력 가능
      style: TextStyle(color: mainWhite),
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: mainGrey
        ), // 힌트 텍스트 색상
        hintText: "판수를 입력하세요.",
        fillColor: secondaryBlack,
        filled: true, // 배경색 활성화
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // 둥근 테두리 설정
          borderSide: BorderSide.none, // 테두리 색상 없애기
        ),
      ),
    );
  }
}