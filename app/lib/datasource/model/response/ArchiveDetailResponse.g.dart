// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ArchiveDetailResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchiveDetailResponse _$ArchiveDetailResponseFromJson(
        Map<String, dynamic> json) =>
    ArchiveDetailResponse(
      archiveId: (json['archiveId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      userNickName: json['userNickName'] as String,
      userProfile: json['userProfile'] as String,
      archiveContent: json['archiveContent'] as String,
      gameTitle: json['gameTitle'] as String,
      archiveGamePlayTime: (json['archiveGamePlayTime'] as num).toInt(),
      archiveGamePlayCount: (json['archiveGamePlayCount'] as num).toInt(),
      archiveImageList: (json['archiveImageList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ArchiveDetailResponseToJson(
        ArchiveDetailResponse instance) =>
    <String, dynamic>{
      'archiveId': instance.archiveId,
      'userId': instance.userId,
      'userNickName': instance.userNickName,
      'userProfile': instance.userProfile,
      'archiveContent': instance.archiveContent,
      'gameTitle': instance.gameTitle,
      'archiveGamePlayTime': instance.archiveGamePlayTime,
      'archiveGamePlayCount': instance.archiveGamePlayCount,
      'archiveImageList': instance.archiveImageList,
    };
