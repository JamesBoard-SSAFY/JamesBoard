// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MyPageMissionRecordResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyPageMissionRecordResponse _$MyPageMissionRecordResponseFromJson(
        Map<String, dynamic> json) =>
    MyPageMissionRecordResponse(
      gameTitle: json['gameTitle'] as String,
      gameImage: json['gameImage'] as String,
      gameCategoryList: (json['gameCategoryList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      minAge: (json['minAge'] as num).toInt(),
      gameYear: (json['gameYear'] as num).toInt(),
      minPlayer: (json['minPlayer'] as num).toInt(),
      maxPlayer: (json['maxPlayer'] as num).toInt(),
      difficulty: (json['difficulty'] as num).toInt(),
      playTime: (json['playTime'] as num).toInt(),
      archiveList: (json['archiveList'] as List<dynamic>)
          .map((e) => MyPageArchiveResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyPageMissionRecordResponseToJson(
        MyPageMissionRecordResponse instance) =>
    <String, dynamic>{
      'gameTitle': instance.gameTitle,
      'gameImage': instance.gameImage,
      'gameCategoryList': instance.gameCategoryList,
      'minAge': instance.minAge,
      'gameYear': instance.gameYear,
      'minPlayer': instance.minPlayer,
      'maxPlayer': instance.maxPlayer,
      'difficulty': instance.difficulty,
      'playTime': instance.playTime,
      'archiveList': instance.archiveList,
    };
