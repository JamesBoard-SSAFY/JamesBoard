import 'package:dio/dio.dart';
import 'package:jamesboard/datasource/api/LoginService.dart';
import 'package:jamesboard/util/DioProviderUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datasource/model/request/KakaoTokenLoginRequest.dart';
import '../datasource/model/request/RenewalAccessTokenRequest.dart';
import '../datasource/model/response/RenewalAccessTokenResponse.dart';
import '../main.dart';

class LoginRepository {
  final LoginService _service;

  LoginRepository._(this._service);

  factory LoginRepository.create() {
    final service = LoginService(DioProviderUtil.dio);
    return LoginRepository._(service);
  }

  // ▼ 이하 기존 API들

  // 카카오 로그인 페이지 리다이렉트
  Future<void> goToKakaoLoginPage() => _service.goToKakaoLoginPage();

  // 로그아웃
  Future<void> logout() => _service.logout();

  // AccessToken 갱신 API
  Future<RenewalAccessTokenResponse> renewalAccessToken(
    RenewalAccessTokenRequest request,
  ) =>
      _service.renewalAccessToken(request);

  // 카카오 OAuth 콜백 처리
  Future<RenewalAccessTokenResponse> kakaoCallback(String kakaoAccessToken) =>
      _service.kakaoCallback(kakaoAccessToken);

  // 카카오 토큰 로그인
  Future<RenewalAccessTokenResponse> kakaoTokenLogin(
    KakaoTokenLoginRequest request,
  ) =>
      _service.kakaoTokenLogin(request);
}
