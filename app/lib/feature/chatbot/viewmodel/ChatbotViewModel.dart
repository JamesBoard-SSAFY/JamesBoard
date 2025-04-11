import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/datasource/model/request/chatbot/ChatbotRequest.dart';
import 'package:jamesboard/datasource/model/response/chatbot/ChatbotResponse.dart';
import '../../../main.dart';
import '../../../repository/ChatbotRepository.dart';
import '../../../repository/LoginRepository.dart';

class ChatbotViewModel extends ChangeNotifier {
  final ChatbotRepository _chatbotRepository;
  final LoginRepository _loginRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ChatbotResponse? _chatbotResponse;
  ChatbotResponse? get chatbotResponse => _chatbotResponse;

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  ChatbotViewModel(
    this._chatbotRepository,
    this._loginRepository,
  );

  // 현재 시간 포맷 함수
  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour < 12 ? '오전' : '오후';
    return '$period $hour:$minute';
  }

  Future<void> writeChat(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    // 사용자의 메시지를 추가
    _messages.add(ChatMessage(
      message: userMessage,
      isMe: true,
      time: _getCurrentTime(),
    ));
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      logger.d("chatbotViewModel try : ${_chatbotResponse?.message}");

      // 서버 요청
      final request = ChatbotRequest(query: userMessage);
      _chatbotResponse = await _chatbotRepository.writeChat(request);

      logger.d("chatbotViewModel response : ${_chatbotResponse?.message}");

      // 챗봇 응답 추가
      if (_chatbotResponse != null) {
        _messages.add(ChatMessage(
          message: _chatbotResponse!.message,
          isMe: false,
          time: _getCurrentTime(),
        ));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _loginRepository.logout();
      }
    } catch (e) {
      _messages.add(ChatMessage(
        message: "오류가 발생했습니다. 다시 시도해주세요.",
        isMe: false,
        time: _getCurrentTime(),
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
