import 'package:jamesboard/datasource/api/ChatbotService.dart';
import 'package:jamesboard/datasource/model/request/chatbot/ChatbotRequest.dart';
import 'package:jamesboard/datasource/model/response/chatbot/ChatbotResponse.dart';
import 'package:jamesboard/util/DioProviderUtil.dart';

class ChatbotRepository {
  final ChatbotService _chatbotService;

  ChatbotRepository(this._chatbotService);

  factory ChatbotRepository.create() {
    final dio = DioProviderUtil.chatDio;

    final service = ChatbotService(dio);
    return ChatbotRepository(service);
  }

  Future<ChatbotResponse> writeChat(ChatbotRequest request) =>
      _chatbotService.writeChat(request);
}
