import 'package:json_annotation/json_annotation.dart';

part 'UserActivityPatchRequest.g.dart';

@JsonSerializable()
class UserActivityPatchRequest {
  final double rating;

  UserActivityPatchRequest({required this.rating});

  factory UserActivityPatchRequest.fromJson(Map<String, dynamic> json) =>
      _$UserActivityPatchRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserActivityPatchRequestToJson(this);
}
