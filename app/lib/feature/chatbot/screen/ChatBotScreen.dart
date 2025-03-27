import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/feature/chatbot/widget/ChatBubbleChatBot.dart';
import 'package:jamesboard/feature/chatbot/widget/TextFieldChatBotMessage.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/widget/appbar/DefaultCommonAppBar.dart';

class ChatBotScreen extends StatefulWidget {
  final String title;

  const ChatBotScreen({super.key, required this.title});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _chatController = TextEditingController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      message: '요원 hyuun, Q입니다. 임무 계획 수립을 위해 다음 정보를 한 번에 전달해 주시기 바랍니다.',
      isMe: false,
      time: '오전 08:13',
    ),
    _ChatMessage(
      message: '장르, 참여 인원, 난이도, 게임당 플레이 시간 등 이 정보를 바탕으로, 최적화 보드게임 작전을 준비하겠습니다.',
      isMe: false,
      time: '오전 08:14',
    ),
  ];

  // 임시 메시지 보내기.
  void _sendMessage() {
    final text = _chatController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        message: text,
        isMe: true,
        time: _getCurrentTime(),
      ));
      _chatController.clear();
    });
  }

  // 시간 구하기.
  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? '오전' : '오후';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    return '$period $formattedHour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      appBar: DefaultCommonAppBar(
        title: widget.title,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        child: Column(
          children: [
            // 채팅 영역
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 32),
                reverse: false,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return ChatBubbleChatBot(
                    message: msg.message,
                    isMe: msg.isMe,
                    time: msg.time,
                  );
                },
              ),
            ),

            // 입력 바
            TextFieldChatBotMessage(
              onSend: (message) {
                setState(() {
                  _messages.add(
                    _ChatMessage(
                      message: message,
                      isMe: true,
                      time: _getCurrentTime(),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String message;
  final bool isMe;
  final String time;

  _ChatMessage({
    required this.message,
    required this.isMe,
    required this.time,
  });
}
