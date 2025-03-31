import 'package:json_annotation/json_annotation.dart';

part 'MyPageUserIdResponse.g.dart';

@JsonSerializable()
class MyPageUserIdResponse {
  final int userId;

  MyPageUserIdResponse({
    required this.userId,
  });

  factory MyPageUserIdResponse.fromJson(Map<String, dynamic> json) => _$MyPageUserIdResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MyPageUserIdResponseToJson(this);
}