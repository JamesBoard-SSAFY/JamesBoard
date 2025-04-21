// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatbotResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatbotResponse _$ChatbotResponseFromJson(Map<String, dynamic> json) =>
    ChatbotResponse(
      gameId: json['gameId'] as int?,
      chatType: json['chatType'] as int,
      message: json['message'] as String,
      thumbnail: json['thumbnail'] as String?,
    );

Map<String, dynamic> _$ChatbotResponseToJson(ChatbotResponse instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'chatType': instance.chatType,
      'message': instance.message,
      'thumbnail': instance.thumbnail,
    };
