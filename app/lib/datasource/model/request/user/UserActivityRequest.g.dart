// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserActivityRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActivityRequest _$UserActivityRequestFromJson(Map<String, dynamic> json) =>
    UserActivityRequest(
      userId: (json['userId'] as num).toInt(),
      gameId: (json['gameId'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
    );

Map<String, dynamic> _$UserActivityRequestToJson(
        UserActivityRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'gameId': instance.gameId,
      'rating': instance.rating,
    };
