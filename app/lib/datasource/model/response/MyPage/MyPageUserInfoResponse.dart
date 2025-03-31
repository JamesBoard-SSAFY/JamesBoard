import 'package:json_annotation/json_annotation.dart';

part 'MyPageUserInfoResponse.g.dart';

@JsonSerializable()
class MyPageUserInfoResponse {
  final String userProfile;
  final String userNickname;

  MyPageUserInfoResponse({
    required this.userProfile,
    required this.userNickname,
  });

  factory MyPageUserInfoResponse.fromJson(Map<String, dynamic> json) => _$MyPageUserInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MyPageUserInfoResponseToJson(this);
}