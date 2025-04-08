import 'package:json_annotation/json_annotation.dart';

part 'ChatbotResponse.g.dart';

@JsonSerializable()
class ChatbotResponse {
  final int? gameId;
  final int chatType;
  final String message;
  final String? thumbnail;

  ChatbotResponse({
    this.gameId,
    required this.chatType,
    required this.message,
    this.thumbnail,
  });

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatbotResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatbotResponseToJson(this);
}
