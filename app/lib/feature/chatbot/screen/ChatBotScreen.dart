import 'package:flutter/material.dart';
import 'package:jamesboard/main.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    chatbotViewModel = Provider.of<ChatbotViewModel>(context, listen: false);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: chatbotViewModel,
      child: Consumer<ChatbotViewModel>(
        builder: (context, viewModel, child) {
          _scrollToBottom();

          return Scaffold(
            backgroundColor: mainBlack,
            appBar: DefaultCommonAppBar(title: widget.title),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                    child: ListView.builder(
                      controller: _scrollController,
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
                ),

                // TextFieldChatBotMessage는 패딩 영향을 받지 않도록 Column의 마지막 위젯으로 이동
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  child: TextFieldChatBotMessage(
                    onSend: (message) {
                      viewModel.writeChat(message);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
