// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ArchiveDetailResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchiveDetailResponse _$ArchiveDetailResponseFromJson(
        Map<String, dynamic> json) =>
    ArchiveDetailResponse(
      archiveId: (json['archiveId'] as num).toInt(),
      userNickName: json['userNickName'] as String,
      userProfile: json['userProfile'] as String,
      archiveContent: json['archiveContent'] as String,
      gameTitle: json['gameTitle'] as String,
      archiveGamePlayTime: (json['archiveGamePlayTime'] as num).toInt(),
      archiveImageList: (json['archiveImageList'] as List<dynamic>)
          .map((e) => ArchiveImageList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArchiveDetailResponseToJson(
        ArchiveDetailResponse instance) =>
    <String, dynamic>{
      'archiveId': instance.archiveId,
      'userNickName': instance.userNickName,
      'userProfile': instance.userProfile,
      'archiveContent': instance.archiveContent,
      'gameTitle': instance.gameTitle,
      'archiveGamePlayTime': instance.archiveGamePlayTime,
      'archiveImageList': instance.archiveImageList,
    };

ArchiveImageList _$ArchiveImageListFromJson(Map<String, dynamic> json) =>
    ArchiveImageList(
      archiveImageUrl: json['archiveImageUrl'] as String,
    );

Map<String, dynamic> _$ArchiveImageListToJson(ArchiveImageList instance) =>
    <String, dynamic>{
      'archiveImageUrl': instance.archiveImageUrl,
    };
