import 'package:json_annotation/json_annotation.dart';

part 'MyPageUserInfoRequest.g.dart';

@JsonSerializable()
class MyPageUserInfoRequest {
  final String userName;
  final String userProfile;

  MyPageUserInfoRequest({
    required this.userName,
    required this.userProfile,
  });

  factory MyPageUserInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$MyPageUserInfoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MyPageUserInfoRequestToJson(this);
}