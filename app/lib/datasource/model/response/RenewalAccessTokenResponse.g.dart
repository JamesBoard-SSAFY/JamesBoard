// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RenewalAccessTokenResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenewalAccessTokenResponse _$RenewalAccessTokenResponseFromJson(
        Map<String, dynamic> json) =>
    RenewalAccessTokenResponse(
      userId: (json['userId'] as num).toInt(),
      userNickname: json['userNickname'] as String,
      userProfile: json['userProfile'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$RenewalAccessTokenResponseToJson(
        RenewalAccessTokenResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userNickname': instance.userNickname,
      'userProfile': instance.userProfile,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
