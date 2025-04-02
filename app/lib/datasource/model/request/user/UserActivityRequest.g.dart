part of 'UserActivityRequest.dart';

UserActivityRequest _$UserActivityRequestFromJson(Map<String, dynamic> json) =>
    UserActivityRequest(
      userId: json['userId'] as int,
      gameId: json['gameId'] as int,
      rating: (json['rating'] as num).toDouble(),
    );

Map<String, dynamic> _$UserActivityRequestToJson(
        UserActivityRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'gameId': instance.gameId,
      'rating': instance.rating,
    };
