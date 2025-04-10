// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MyPageGameStatsResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyPageGameStatsResponse _$MyPageGameStatsResponseFromJson(
        Map<String, dynamic> json) =>
    MyPageGameStatsResponse(
      totalPlayed: (json['totalPlayed'] as num).toInt(),
      genreStats: (json['genreStats'] as List<dynamic>)
          .map((e) => GenreStats.fromJson(e as Map<String, dynamic>))
          .toList(),
      topPlayedGames: (json['topPlayedGames'] as List<dynamic>)
          .map((e) => TopPlayedGame.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyPageGameStatsResponseToJson(
        MyPageGameStatsResponse instance) =>
    <String, dynamic>{
      'totalPlayed': instance.totalPlayed,
      'genreStats': instance.genreStats,
      'topPlayedGames': instance.topPlayedGames,
    };
