// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BoardGameDetailResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardGameDetailResponse _$BoardGameDetailResponseFromJson(
        Map<String, dynamic> json) =>
    BoardGameDetailResponse(
      gameId: (json['gameId'] as num).toInt(),
      gameTitle: json['gameTitle'] as String,
      gameImage: json['gameImage'] as String,
      gameCategories: (json['gameCategories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      gameThemes: (json['gameThemes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      gameDesigners: (json['gameDesigners'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      gamePublisher: json['gamePublisher'] as String,
      gameYear: (json['gameYear'] as num).toInt(),
      gameMinAge: (json['gameMinAge'] as num).toInt(),
      minPlayers: (json['minPlayers'] as num).toInt(),
      maxPlayers: (json['maxPlayers'] as num).toInt(),
      difficulty: (json['difficulty'] as num).toInt(),
      playTime: (json['playTime'] as num).toInt(),
      description: json['description'] as String,
      gameRating: (json['gameRating'] as num).toDouble(),
    );

Map<String, dynamic> _$BoardGameDetailResponseToJson(
        BoardGameDetailResponse instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'gameTitle': instance.gameTitle,
      'gameImage': instance.gameImage,
      'gameCategories': instance.gameCategories,
      'gameThemes': instance.gameThemes,
      'gameDesigners': instance.gameDesigners,
      'gamePublisher': instance.gamePublisher,
      'gameYear': instance.gameYear,
      'gameMinAge': instance.gameMinAge,
      'minPlayers': instance.minPlayers,
      'maxPlayers': instance.maxPlayers,
      'difficulty': instance.difficulty,
      'playTime': instance.playTime,
      'description': instance.description,
      'gameRating': instance.gameRating,
    };
