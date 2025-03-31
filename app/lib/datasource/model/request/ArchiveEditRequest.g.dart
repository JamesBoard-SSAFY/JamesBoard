// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ArchiveEditRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchiveEditRequest _$ArchiveEditRequestFromJson(Map<String, dynamic> json) =>
    ArchiveEditRequest(
      gameId: (json['gameId'] as num).toInt(),
      archiveGamePlayCount: (json['archiveGamePlayCount'] as num).toInt(),
      archiveImageList: (json['archiveImageList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      archiveContent: json['archiveContent'] as String,
      archiveGamePlayTime: (json['archiveGamePlayTime'] as num).toInt(),
    );

Map<String, dynamic> _$ArchiveEditRequestToJson(ArchiveEditRequest instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'archiveContent': instance.archiveContent,
      'archiveImageList': instance.archiveImageList,
      'archiveGamePlayTime': instance.archiveGamePlayTime,
      'archiveGamePlayCount': instance.archiveGamePlayCount,
    };
