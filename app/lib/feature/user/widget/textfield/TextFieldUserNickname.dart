import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../../../../constants/FontString.dart';

class TextFieldUserNickname extends StatefulWidget {
  final String userName;
  final Function(String, bool) onNicknameChanged;

  const TextFieldUserNickname({
    super.key,
    required this.userName,
    required this.onNicknameChanged,
  });

  @override
  State<TextFieldUserNickname> createState() => _TextFieldUserNicknameState();
}

class _TextFieldUserNicknameState extends State<TextFieldUserNickname> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.userName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateNickname(String text) {
    bool isValid = true;

    // 허용되지 않은 문자 제거
    String filteredText = text.replaceAll(RegExp(r'[^a-zA-Z0-9ㄱ-ㅎ가-힣!?.,_@#&$%-]'), '');

    if (filteredText.length < 2) {
      _errorText = "닉네임은 최소 2자 이상 입력해야 합니다.";
      isValid = false;
    } else if (text != filteredText) {
      _errorText = "닉네임에는 한글, 영문, 숫자 및 특수문자 (!?.,_@#&\$%-) 만 사용할 수 있습니다.";
      isValid = false;
    } else {
      _errorText = null;
    }

    // 입력 필드 값 수정 (잘못된 문자 제거)
    if (text != filteredText) {
      _controller.text = filteredText;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: filteredText.length),
      );
    }

    widget.onNicknameChanged(filteredText, isValid); // 부모 위젯으로 전달
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 16,
      controller: _controller,
      style: TextStyle(
        color: mainWhite,
        fontFamily: FontString.pretendardSemiBold,
      ),
      decoration: InputDecoration(
        hintText: AppString.userNicknameHint,
        hintStyle: TextStyle(
          fontFamily: FontString.pretendardSemiBold,
          color: mainGrey,
        ),
        filled: true,
        fillColor: secondaryBlack,
        counterText: '',
        errorText: _errorText,
        errorMaxLines: 2,
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
          icon: SvgPicture.asset(
            IconPath.circularClose,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(mainGold, BlendMode.srcIn),
          ),
          onPressed: () {
            _controller.clear();
            _validateNickname(''); // 검증 다시 실행
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: _validateNickname, // 닉네임 입력 시 검증 실행
    );
  }
}
