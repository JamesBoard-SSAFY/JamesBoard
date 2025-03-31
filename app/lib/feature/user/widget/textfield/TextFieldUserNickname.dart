import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../../../../constants/FontString.dart';

class TextFieldUserNickname extends StatefulWidget {
  final String userName;

  const TextFieldUserNickname({
    super.key,
    required this.userName,
  });

  @override
  State<TextFieldUserNickname> createState() => _TextFieldUserNicknameState();
}

class _TextFieldUserNicknameState extends State<TextFieldUserNickname> {
  late TextEditingController _controller;

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

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 16,
      inputFormatters: [LengthLimitingTextInputFormatter(16)],
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
            setState(() {}); // UI 갱신
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (text) {
        setState(() {}); // X 버튼 표시 여부 업데이트
      },
    );
  }
}

