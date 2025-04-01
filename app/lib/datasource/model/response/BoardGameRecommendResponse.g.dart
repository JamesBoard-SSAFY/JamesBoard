// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BoardGameRecommendResponse.dart';

// ***************************************************************************
// JsonSerializableGenerator
// ***************************************************************************

BoardGameRecommendResponse _$BoardGameRecommendResponseFromJson(
        Map<String, dynamic> json) =>
    BoardGameRecommendResponse(
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

Map<String, dynamic> _$BoardGameRecommendResponseToJson(
        BoardGameRecommendResponse instance) =>
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
