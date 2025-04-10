import 'package:json_annotation/json_annotation.dart';

part 'UserActivityResponse.g.dart';

@JsonSerializable()
class UserActivityResponse {
  final int userActivityId;

  UserActivityResponse({required this.userActivityId});

  factory UserActivityResponse.fromJson(Map<String, dynamic> json) =>
      _$UserActivityResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserActivityResponseToJson(this);
}
