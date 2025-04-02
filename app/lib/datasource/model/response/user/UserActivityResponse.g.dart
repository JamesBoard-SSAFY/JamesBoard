part of 'UserActivityResponse.dart';

// ***************************************************************************
// JsonSerializableGenerator
// ***************************************************************************

UserActivityResponse _$UserActivityResponseFromJson(Map<String, dynamic> json) {
  return UserActivityResponse(
    userActivityId: json['userActivityId'] as int,
  );
}

Map<String, dynamic> _$UserActivityResponseToJson(
        UserActivityResponse instance) =>
    <String, dynamic>{
      'userActivityId': instance.userActivityId,
    };
