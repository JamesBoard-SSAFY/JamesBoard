// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MyPageArchiveResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyPageArchiveResponse _$MyPageArchiveResponseFromJson(
        Map<String, dynamic> json) =>
    MyPageArchiveResponse(
      archiveId: (json['archiveId'] as num).toInt(),
      createdAt: json['createdAt'] as String,
      archiveContent: json['archiveContent'] as String,
      archiveGamePlayCount: (json['archiveGamePlayCount'] as num).toInt(),
      archiveImage: json['archiveImage'] as String,
    );

Map<String, dynamic> _$MyPageArchiveResponseToJson(
        MyPageArchiveResponse instance) =>
    <String, dynamic>{
      'archiveId': instance.archiveId,
      'createdAt': instance.createdAt,
      'archiveContent': instance.archiveContent,
      'archiveGamePlayCount': instance.archiveGamePlayCount,
      'archiveImage': instance.archiveImage,
    };
