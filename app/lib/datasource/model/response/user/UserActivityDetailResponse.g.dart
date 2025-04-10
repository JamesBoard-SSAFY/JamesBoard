// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserActivityDetailResponse.dart';

// ***************************************************************************
// JsonSerializableGenerator
// ***************************************************************************

UserActivityDetailResponse _$UserActivityDetailResponseFromJson(
    Map<String, dynamic> json) {
  return UserActivityDetailResponse(
    userActivityId: json['userActivityId'] as int?,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    modifiedAt: json['modifiedAt'] == null
        ? null
        : DateTime.parse(json['modifiedAt'] as String),
    userActivityRating: (json['userActivityRating'] as num?)?.toDouble(),
    userActivityTime: json['userActivityTime'] as int?,
    gameId: json['gameId'] as int?,
    userId: json['userId'] as int?,
  );
}

Map<String, dynamic> _$UserActivityDetailResponseToJson(
        UserActivityDetailResponse instance) =>
    <String, dynamic>{
      'userActivityId': instance.userActivityId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'modifiedAt': instance.modifiedAt?.toIso8601String(),
      'userActivityRating': instance.userActivityRating,
      'userActivityTime': instance.userActivityTime,
      'gameId': instance.gameId,
      'userId': instance.userId,
    };
