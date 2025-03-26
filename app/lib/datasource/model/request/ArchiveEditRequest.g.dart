// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ArchiveEditRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchiveEditRequest _$ArchiveEditRequestFromJson(Map<String, dynamic> json) =>
    ArchiveEditRequest(
      gameId: (json['gameId'] as num).toInt(),
      archiveGamePlayCount: json['archiveGamePlayCount'] as String,
      archiveImageList: (json['archiveImageList'] as List<dynamic>)
          .map((e) => ArchiveImageList.fromJson(e as Map<String, dynamic>))
          .toList(),
      archiveContent: json['archiveContent'] as String,
      archiveGamePlayTime: json['archiveGamePlayTime'] as String,
    );

Map<String, dynamic> _$ArchiveEditRequestToJson(ArchiveEditRequest instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'archiveContent': instance.archiveContent,
      'archiveImageList': instance.archiveImageList,
      'archiveGamePlayTime': instance.archiveGamePlayTime,
      'archiveGamePlayCount': instance.archiveGamePlayCount,
    };

ArchiveImageList _$ArchiveImageListFromJson(Map<String, dynamic> json) =>
    ArchiveImageList(
      archiveImageUrl: json['archiveImageUrl'] as String,
    );

Map<String, dynamic> _$ArchiveImageListToJson(ArchiveImageList instance) =>
    <String, dynamic>{
      'archiveImageUrl': instance.archiveImageUrl,
    };
