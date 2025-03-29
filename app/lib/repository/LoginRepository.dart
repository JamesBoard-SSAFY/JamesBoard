import 'package:dio/dio.dart';
import 'package:jamesboard/datasource/api/LoginService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datasource/model/request/KakaoTokenLoginRequest.dart';
import '../datasource/model/request/RenewalAccessTokenRequest.dart';
import '../datasource/model/response/RenewalAccessTokenResponse.dart';
import '../main.dart';

class LoginRepository {
  final LoginService _service;
  final Dio _dio;

  LoginRepository._(this._service, this._dio);

  factory LoginRepository.create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://j12d205.p.ssafy.io/',
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await storage.read(key: 'accessToken');

          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          return handler.next(options);
        },
        onError: (DioError e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshed = await refreshAccessToken();
            if (refreshed) {
              // 재발급 성공 시, 원래 요청의 헤더를 갱신하고 재시도
              final newAccessToken = await storage.read(key: 'accessToken');

              if (newAccessToken != null && newAccessToken.isNotEmpty) {
                // 원래 요청 정보를 복제
                final clonedRequest = e.requestOptions;
                clonedRequest.headers['Authorization'] =
                    'Bearer $newAccessToken';

                try {
                  // 재시도
                  final retryResponse = await dio.fetch(clonedRequest);
                  return handler.resolve(retryResponse);
                } catch (err) {
                  // 재시도 중 또 에러가 나면 그대로 전달
                  return handler.next(e);
                }
              }
            }
          }
          // 3) 401이 아니거나, 재발급 실패 시 → 그대로 에러 전달
          return handler.next(e);
        },
      ),
    );

    final service = LoginService(dio);
    return LoginRepository._(service, dio);
  }

  /// refreshToken을 사용해 새 accessToken 발급
  static Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await storage.read(key: 'refreshToken');

      if (refreshToken == null || refreshToken.isEmpty) {
        return false; // refreshToken이 없으면 재발급 불가
      }

      // 새 accessToken 요청
      final dioForRefresh = Dio();
      final serviceForRefresh = LoginService(dioForRefresh);

      final renewalResponse = await serviceForRefresh.renewalAccessToken(
        RenewalAccessTokenRequest(refreshToken: refreshToken),
      );

      // 발급받은 것들 저장
      await storage.write(
        key: 'accessToken',
        value: renewalResponse.accessToken,
      );
      await storage.write(
        key: 'refreshToken',
        value: renewalResponse.refreshToken,
      );
      await storage.write(
        key: 'userId',
        value: renewalResponse.userId.toString(),
      );

      logger.d('새 accessToken 발급 성공: ${renewalResponse.accessToken}');
      return true;
    } catch (err) {
      logger.e('토큰 재발급 실패: $err');
      return false;
    }
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
