// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MyPagePlayedGames.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyPagePlayedGames _$MyPagePlayedGamesFromJson(Map<String, dynamic> json) =>
    MyPagePlayedGames(
      gameId: (json['gameId'] as num).toInt(),
      gameImage: json['gameImage'] as String,
    );

Map<String, dynamic> _$MyPagePlayedGamesToJson(MyPagePlayedGames instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'gameImage': instance.gameImage,
    };
