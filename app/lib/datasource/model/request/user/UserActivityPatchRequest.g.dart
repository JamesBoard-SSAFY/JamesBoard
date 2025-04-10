// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserActivityPatchRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActivityPatchRequest _$UserActivityPatchRequestFromJson(
        Map<String, dynamic> json) =>
    UserActivityPatchRequest(
      rating: (json['rating'] as num).toDouble(),
    );

Map<String, dynamic> _$UserActivityPatchRequestToJson(
        UserActivityPatchRequest instance) =>
    <String, dynamic>{
      'rating': instance.rating,
    };
