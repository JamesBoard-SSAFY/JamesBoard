import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/feature/chatbot/widget/ChatBubbleChatBot.dart';
import 'package:jamesboard/feature/chatbot/widget/TextFieldChatBotMessage.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/dummy/AppDummyData.dart';
import 'package:jamesboard/widget/appbar/DefaultCommonAppBar.dart';

class ChatBotScreen extends StatefulWidget {
  final String title;

  const ChatBotScreen({super.key, required this.title});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _chatController = TextEditingController();

  // 임시 메시지 보내기.
  void _sendMessage() {
    final text = _chatController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      AppDummyData.messages.add(ChatMessage(
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
                itemCount: AppDummyData.messages.length,
                itemBuilder: (context, index) {
                  final msg = AppDummyData.messages[index];
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
                  AppDummyData.messages.add(
                    ChatMessage(
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

class ChatMessage {
  final String message;
  final bool isMe;
  final String time;

  ChatMessage({
    required this.message,
    required this.isMe,
    required this.time,
  });
}
