// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MyPageUserInfoResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyPageUserInfoResponse _$MyPageUserInfoResponseFromJson(
        Map<String, dynamic> json) =>
    MyPageUserInfoResponse(
      userProfile: json['userProfile'] as String,
      userNickname: json['userNickname'] as String,
    );

Map<String, dynamic> _$MyPageUserInfoResponseToJson(
        MyPageUserInfoResponse instance) =>
    <String, dynamic>{
      'userProfile': instance.userProfile,
      'userNickname': instance.userNickname,
    };
