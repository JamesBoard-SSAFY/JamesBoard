import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/theme/Colors.dart';

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
      controller: _controller,
      style: TextStyle(color: mainWhite, fontFamily: 'PretendardSemiBold'),
      decoration: InputDecoration(
        hintText: "닉네임을 입력하세요",
        hintStyle: TextStyle(
          fontFamily: 'PretendardSemiBold',
          color: mainGrey
        ),
        filled: true,
        fillColor: secondaryBlack,
        suffixIcon: _controller.text.isNotEmpty
          ?
          IconButton(
            icon: SvgPicture.asset(
              'assets/image/icon_circular_close.svg',
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
