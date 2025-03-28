import 'package:dio/dio.dart';
import 'package:jamesboard/datasource/api/LoginService.dart';

import '../datasource/model/request/RenewalAccessTokenRequest.dart';
import '../datasource/model/response/RenewalAccessTokenResponse.dart';

class LoginRepository {
  final LoginService _service;

  LoginRepository._(this._service);

  factory LoginRepository.create() {
    final dio =
        Dio(BaseOptions(baseUrl: 'https://j12d205.p.ssafy.io/', headers: {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $accessToken',
    }));

    final service = LoginService(dio);
    return LoginRepository._(service);
  }

  // 카카오 로그인 페이지 리다이렉트
  Future<void> goToKakaoLoginPage() => _service.goToKakaoLoginPage();

  // 로그아웃
  Future<void> logout() => _service.logout();

  // AccessToken 갱신
  Future<RenewalAccessTokenResponse> renewalAccessToken(
          RenewalAccessTokenRequest request) =>
      _service.renewalAccessToken(request);
}
