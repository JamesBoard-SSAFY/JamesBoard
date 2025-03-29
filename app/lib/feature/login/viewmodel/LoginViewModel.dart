import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/datasource/model/request/KakaoTokenLoginRequest.dart';
import 'package:jamesboard/datasource/model/request/RenewalAccessTokenRequest.dart';
import 'package:jamesboard/feature/login/screen/LoginScreen.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/repository/LoginRepository.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../survey/screen/SurveyCategoryScreen.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginRepository _loginRepository;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  LoginViewModel(this._loginRepository);

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    logger.d('login() 실행 시작');
    _setLoading(true);

    try {
      OAuthToken token;

      // 카카오톡 설치 여부에 따라 로그인 방식 결정
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      logger.d('카카오 로그인 성공! accessToken: ${token.accessToken}');
      logger.d('카카오 로그인 성공! refreshToken: ${token.refreshToken}');

      // 카카오 콜백
      final request =
          KakaoTokenLoginRequest(kakaoAccessToken: token.accessToken);
      final response = await _loginRepository.kakaoTokenLogin(request);

      await storage.write(key: 'accessToken', value: response.accessToken);
      await storage.write(key: 'refreshToken', value: response.refreshToken);
      await storage.write(key: 'userId', value: response.userId.toString());

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SurveyCategoryScreen(),
          ),
        );
      }
    } on DioError catch (e) {
      logger.e('서버 로그인 API 실패 : $e');
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
      if (scaffoldMessenger != null) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('서버 로그인 실패')),
        );
      }
    } catch (e) {
      logger.d('알 수 없는 로그인 실패: $e');

      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
      if (scaffoldMessenger != null) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('알 수 없는 로그인 실패')),
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _loginRepository.logout();
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        logger.d('로그아웃 시 401 발생 - 토큰 갱신 시도');

        final refreshToken = await storage.read(key: 'refreshToken');

        if (refreshToken == null || refreshToken.isEmpty) {
          logger.e('Refresh token이 존재하지 않습니다.');
          rethrow;
        }

        final request = RenewalAccessTokenRequest(refreshToken: refreshToken);
        final renewalResponse =
            await _loginRepository.renewalAccessToken(request);

        storage.deleteAll();

        if (renewalResponse.accessToken.isNotEmpty) {
          await storage.write(
              key: 'accessToken', value: renewalResponse.accessToken);
          await storage.write(
              key: 'refreshToken', value: renewalResponse.refreshToken);
          await storage.write(
              key: 'userId', value: renewalResponse.userId.toString());

          await _loginRepository.logout();
        } else {
          logger.e('토큰 갱신 실패로 로그아웃 재시도 불가');
          rethrow;
        }
      } else {
        // 401 외 다른 에러는 그대로 throw
        rethrow;
      }
    }

    await storage.deleteAll();

    await UserApi.instance.logout();
    logger.d('카카오 로그아웃 성공');

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}
