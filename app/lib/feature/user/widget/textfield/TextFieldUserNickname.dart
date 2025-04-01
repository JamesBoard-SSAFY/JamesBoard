import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../../../../constants/FontString.dart';

class TextFieldUserNickname extends StatefulWidget {
  const TextFieldUserNickname({super.key});

  @override
  State<TextFieldUserNickname> createState() => _TextFieldUserNicknameState();
}

class _TextFieldUserNicknameState extends State<TextFieldUserNickname> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 16, // 최대 길이 설정
      inputFormatters: [LengthLimitingTextInputFormatter(16)],
      controller: _controller,
      style: TextStyle(
        color: mainWhite,
        fontFamily: FontString.pretendardSemiBold,
      ),
      decoration: InputDecoration(
        hintText: AppString.userNicknameHint,
        hintStyle: TextStyle(
            fontFamily: FontString.pretendardSemiBold, color: mainGrey),
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
                  _controller.clear(); // X 버튼 클릭 시 텍스트 삭제
                  setState(() {}); // UI 갱신
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // 둥근 테두리 설정
          borderSide: BorderSide.none, // 테두리 색상 없애기
        ),
      ),
      onChanged: (text) {
        setState(() {}); // 입력값이 바뀔 때 X 버튼을 업데이트하기 위함
      },
    );
  }
}
