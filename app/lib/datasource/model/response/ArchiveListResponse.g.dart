// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ArchiveListResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchiveListResponse _$ArchiveListResponseFromJson(Map<String, dynamic> json) =>
    ArchiveListResponse(
      archiveId: (json['archiveId'] as num).toInt(),
      archiveImage: json['archiveImage'] as String,
    );

Map<String, dynamic> _$ArchiveListResponseToJson(
        ArchiveListResponse instance) =>
    <String, dynamic>{
      'archiveId': instance.archiveId,
      'archiveImage': instance.archiveImage,
    };
