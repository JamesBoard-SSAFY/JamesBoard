import 'package:json_annotation/json_annotation.dart';

part 'RenewalAccessTokenRequest.g.dart';

@JsonSerializable()
class RenewalAccessTokenRequest {
  final String refreshToken;

  RenewalAccessTokenRequest({
    required this.refreshToken,
  });

  factory RenewalAccessTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RenewalAccessTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RenewalAccessTokenRequestToJson(this);
}
