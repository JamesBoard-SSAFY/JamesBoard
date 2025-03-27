import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';

class TextFieldChatBotMessage extends StatefulWidget {
  const TextFieldChatBotMessage({super.key});

  @override
  _TextFieldChatBotMessageState createState() =>
      _TextFieldChatBotMessageState();
}

class _TextFieldChatBotMessageState extends State<TextFieldChatBotMessage> {
  final TextEditingController _controller = TextEditingController();
  final Logger logger = Logger();

  // 문자 처리 - 공백만, 특수 기호만 입력, 이모지, 외국어(일본어, 중국어 등) 입력 불가
  bool _isValidInput(String text) {
    final regex = RegExp(r'[a-zA-Z0-9가-힣]');
    return regex.hasMatch(text.trim());
  }

  // ✅ 메시지 전송 함수
  void _onSend() {
    String message = _controller.text.trim();

    if (message.isNotEmpty && _isValidInput(message)) {
      logger.d("ChatBot: $message");

      FocusScope.of(context).unfocus();

      // SnackBar 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('메시지 전송: $message'),
          duration: Duration(seconds: 2),
        ),
      );

      _controller.clear();
    } else {
      // 유효하지 않은 입력
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('올바른 메시지를 입력하세요!'),
          duration: Duration(seconds: 2),
          backgroundColor: mainRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: secondaryBlack,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLength: 100, // 최대 길이 설정
              inputFormatters: [LengthLimitingTextInputFormatter(100)],
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '메시지 입력',
                hintStyle: TextStyle(
                  color: mainGrey,
                ),
                border: InputBorder.none,
                counterText: '',
              ),
              style: TextStyle(
                color: mainWhite,
                fontSize: 16,
              ),
              onEditingComplete: _onSend, // 키패드 완료 버튼
            ),
          ),
          // 전송 버튼 (SVG 아이콘)
          GestureDetector(
            onTap: _onSend,
            child: SvgPicture.asset(
              'assets/image/icon_arrow_up.svg',
              width: 34,
              height: 34,
            ),
          ),
        ],
      ),
    );
  }
}
