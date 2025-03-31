// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BoardGameResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardGameResponse _$BoardGameResponseFromJson(Map<String, dynamic> json) =>
    BoardGameResponse(
      gameId: (json['gameId'] as num).toInt(),
      gameTitle: json['gameTitle'] as String,
      gameImage: json['gameImage'] as String,
      gameCategory: json['gameCategory'] as String,
      minPlayer: (json['minPlayer'] as num).toInt(),
      maxPlayer: (json['maxPlayer'] as num).toInt(),
      difficulty: (json['difficulty'] as num).toInt(),
      playTime: (json['playTime'] as num).toInt(),
      gameDescription: json['gameDescription'] as String,
    );

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
