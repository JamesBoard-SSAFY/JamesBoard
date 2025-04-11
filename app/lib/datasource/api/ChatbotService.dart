import 'package:dio/dio.dart';
import 'package:jamesboard/datasource/model/response/chatbot/ChatbotResponse.dart';
import 'package:jamesboard/main.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/error_logger.dart';

import '../model/request/chatbot/ChatbotRequest.dart';

part 'ChatbotService.g.dart';

@RestApi(baseUrl: "http://j12d205.p.ssafy.io:9098")
abstract class ChatbotService {
  factory ChatbotService(Dio dio, {String baseUrl}) = _ChatbotService;

  @POST("/fastapi/chat")
  Future<ChatbotResponse> writeChat(@Body() ChatbotRequest request);
}
