import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jamesboard/feature/chatbot/widget/ChatBubbleChatBot.dart';
import 'package:jamesboard/feature/chatbot/widget/TextFieldChatBotMessage.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/widget/appbar/DefaultCommonAppBar.dart';
import 'package:jamesboard/feature/chatbot/viewmodel/ChatbotViewModel.dart';

class ChatBotScreen extends StatefulWidget {
  final String title;

  const ChatBotScreen({super.key, required this.title});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  late ChatbotViewModel chatbotViewModel;

  @override
  void initState() {
    super.initState();

    chatbotViewModel = Provider.of<ChatbotViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: chatbotViewModel,
      child: Consumer<ChatbotViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: mainBlack,
            appBar: DefaultCommonAppBar(title: widget.title),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              child: Column(
                children: [
                  // 채팅 목록
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 32),
                      itemCount: viewModel.messages.length,
                      itemBuilder: (context, index) {
                        final msg = viewModel.messages[index];
                        return ChatBubbleChatBot(
                          message: msg.message,
                          isMe: msg.isMe,
                          time: msg.time,
                        );
                      },
                    ),
                  ),

                  // 입력 필드
                  TextFieldChatBotMessage(
                    onSend: (message) {
                      viewModel.writeChat(message);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
