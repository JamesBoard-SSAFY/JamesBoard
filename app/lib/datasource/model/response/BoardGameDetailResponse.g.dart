// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BoardGameDetailResponse.dart';

// ***************************************************************************
// JsonSerializableGenerator
// ***************************************************************************

BoardGameDetailResponse _$BoardGameDetailResponseFromJson(
    Map<String, dynamic> json) {
  return BoardGameDetailResponse(
    gameId: json['gameId'] as int,
    gameTitle: json['gameTitle'] as String,
    gameImage: json['gameImage'] as String,
    gameCategories: (json['gameCategories'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    gameThemes:
        (json['gameThemes'] as List<dynamic>).map((e) => e as String).toList(),
    gameDesigners: (json['gameDesigners'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    gamePublisher: json['gamePublisher'] as String,
    gameYear: json['gameYear'] as int,
    gameMinAge: json['gameMinAge'] as int,
    minPlayers: json['minPlayers'] as int,
    maxPlayers: json['maxPlayers'] as int,
    difficulty: json['difficulty'] as int,
    playTime: json['playTime'] as int,
    description: json['description'] as String,
    gameRating: (json['gameRating'] as num).toDouble(),
  );
}

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
