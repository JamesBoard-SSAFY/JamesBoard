// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TopPlayedGame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopPlayedGame _$TopPlayedGameFromJson(Map<String, dynamic> json) =>
    TopPlayedGame(
      gameId: (json['gameId'] as num).toInt(),
      gameTitle: json['gameTitle'] as String,
      gameImage: json['gameImage'] as String,
      totalPlayCount: (json['totalPlayCount'] as num).toInt(),
    );

Map<String, dynamic> _$TopPlayedGameToJson(TopPlayedGame instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'gameTitle': instance.gameTitle,
      'gameImage': instance.gameImage,
      'totalPlayCount': instance.totalPlayCount,
    };
