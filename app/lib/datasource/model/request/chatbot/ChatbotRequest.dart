import 'package:json_annotation/json_annotation.dart';

part 'ChatbotRequest.g.dart';

@JsonSerializable()
class ChatbotRequest {
  final String query;

  ChatbotRequest({required this.query});

  factory ChatbotRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatbotRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChatbotRequestToJson(this);
}
