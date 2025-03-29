import 'package:json_annotation/json_annotation.dart';

part 'RenewalAccessTokenResponse.g.dart';

@JsonSerializable()
class RenewalAccessTokenResponse {
  final int userId;
  final String userNickname;
  final String userProfile;
  final String accessToken;
  final String refreshToken;

  RenewalAccessTokenResponse({
    required this.userId,
    required this.userNickname,
    required this.userProfile,
    required this.accessToken,
    required this.refreshToken,
  });

  factory RenewalAccessTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RenewalAccessTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RenewalAccessTokenResponseToJson(this);
}
