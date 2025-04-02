import 'package:json_annotation/json_annotation.dart';

part 'UserActivityRequest.g.dart';

@JsonSerializable()
class UserActivityRequest {
  final int userId;
  final int gameId;
  final double rating;

  UserActivityRequest({
    required this.userId,
    required this.gameId,
    required this.rating,
  });

  factory UserActivityRequest.fromJson(Map<String, dynamic> json) =>
      _$UserActivityRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserActivityRequestToJson(this);
}
