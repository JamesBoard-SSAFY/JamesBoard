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

  ChatbotViewModel(
    this._chatbotRepository,
    this._loginRepository,
  );

  Future<void> writeChat(ChatbotRequest request) async {
    _isLoading = true;
    notifyListeners();

    try {
      _chatbotResponse = await _chatbotRepository.writeChat(request);

      logger.d("chatbot response : ${_chatbotResponse}");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리');
        await _loginRepository.logout();
      } else {
        logger.e('기타 DIO 에러 : $e');
      }
    } catch (e) {
      logger.d('카테고리에 맞는 보드게임 갖고오기 실패 : Survey : $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
