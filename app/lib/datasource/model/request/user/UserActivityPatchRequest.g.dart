// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserActivityPatchRequest.dart';

UserActivityPatchRequest _$UserActivityPatchResponseFromJson(
    Map<String, dynamic> json) {
  return UserActivityPatchRequest(
    rating: (json['rating'] as num).toDouble(),
  );
}

Map<String, dynamic> _$UserActivityPatchResponseToJson(
        UserActivityPatchRequest instance) =>
    <String, dynamic>{
      'rating': instance.rating,
    };
