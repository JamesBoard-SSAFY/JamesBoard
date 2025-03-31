// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BoardGameResponse.dart';

// ***************************************************************************
// JsonSerializableGenerator
// ***************************************************************************

BoardGameResponse _$BoardGameResponseFromJson(Map<String, dynamic> json) {
  return BoardGameResponse(
    gameId: json['gameId'] as int,
    gameTitle: json['gameTitle'] as String,
    gameImage: json['gameImage'] as String,
    gameCategory: json['gameCategory'] as String,
    minPlayer: json['minPlayer'] as int,
    maxPlayer: json['maxPlayer'] as int,
    difficulty: json['difficulty'] as int,
    playTime: json['playTime'] as int,
    gameDescription: json['gameDescription'] as String,
  );
}

Map<String, dynamic> _$BoardGameResponseToJson(BoardGameResponse instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'gameTitle': instance.gameTitle,
      'gameImage': instance.gameImage,
      'gameCategory': instance.gameCategory,
      'minPlayer': instance.minPlayer,
      'maxPlayer': instance.maxPlayer,
      'difficulty': instance.difficulty,
      'playTime': instance.playTime,
      'gameDescription': instance.gameDescription,
    };
