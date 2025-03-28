import 'package:dio/dio.dart';
import 'package:jamesboard/datasource/model/response/RenewalAccessTokenResponse.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../model/request/RenewalAccessTokenRequest.dart';

part 'LoginService.g.dart';

@RestApi(baseUrl: "https://j12d205.p.ssafy.io/")
abstract class LoginService {
  factory LoginService(Dio dio, {String baseUrl}) = _LoginService;

  // 카카오 로그인 페이지 리다이렉트
  @GET("/api/auth/login-oauth")
  Future<void> goToKakaoLoginPage();

  // 로그아웃
  @POST("/api/auth/logout")
  Future<void> logout();

  // AccessToken 갱신
  @POST("api/auth/refresh")
  Future<RenewalAccessTokenResponse> renewalAccessToken(
    @Body() RenewalAccessTokenRequest request,
  );

  // 카카오 OAuth 콜백 처리
  @GET("login/oauth2/code/kakao")
  Future<RenewalAccessTokenResponse> kakaoCallback(
    @Query("code") String kakaoAccessToken,
  );
}
