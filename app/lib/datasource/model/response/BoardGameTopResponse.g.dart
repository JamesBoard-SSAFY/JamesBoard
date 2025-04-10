// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BoardGameTopResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardGameTopResponse _$BoardGameTopResponseFromJson(
        Map<String, dynamic> json) =>
    BoardGameTopResponse(
      gameId: (json['gameId'] as num).toInt(),
      bigThumbnail: json['bigThumbnail'] as String,
    );

Map<String, dynamic> _$BoardGameTopResponseToJson(
        BoardGameTopResponse instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'bigThumbnail': instance.bigThumbnail,
    };
