import 'package:json_annotation/json_annotation.dart';

part 'UserActivityDetailResponse.g.dart';

@JsonSerializable()
class UserActivityDetailResponse {
  final int? userActivityId;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final double? userActivityRating;
  final int? userActivityTime;
  final int? gameId;
  final int? userId;

  UserActivityDetailResponse({
    required this.userActivityId,
    required this.createdAt,
    required this.modifiedAt,
    required this.userActivityRating,
    required this.userActivityTime,
    required this.gameId,
    required this.userId,
  });

  factory UserActivityDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$UserActivityDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserActivityDetailResponseToJson(this);
}
