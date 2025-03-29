// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SurveyBoardGameResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyBoardGameResponse _$SurveyBoardGameResponseFromJson(
        Map<String, dynamic> json) =>
    SurveyBoardGameResponse(
      gameId: (json['gameId'] as num).toInt(),
      gameTitle: json['gameTitle'] as String,
    );

Map<String, dynamic> _$SurveyBoardGameResponseToJson(
        SurveyBoardGameResponse instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'gameTitle': instance.gameTitle,
    };
