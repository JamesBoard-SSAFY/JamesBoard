import 'package:json_annotation/json_annotation.dart';

part 'KakaoTokenLoginRequest.g.dart';

@JsonSerializable()
class KakaoTokenLoginRequest {
  final String kakaoAccessToken;

  KakaoTokenLoginRequest({
    required this.kakaoAccessToken,
  });

  factory KakaoTokenLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$KakaoTokenLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$KakaoTokenLoginRequestToJson(this);
}
