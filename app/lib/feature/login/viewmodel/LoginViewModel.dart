import 'package:flutter/material.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/repository/LoginRepository.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel {
  final LoginRepository _loginRepository;

  LoginViewModel(this._loginRepository);

  Future<void> login(BuildContext context) async {
    try {
      OAuthToken token;

      // 카카오톡 설치 여부에 따라 로그인 방식 결정
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      logger.d('카카오 로그인 성공! 액세스 토큰: ${token.accessToken}');

      // 카카오 콜백
      final response = await _loginRepository.kakaoCallback(token.accessToken);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', response.accessToken);
      await prefs.setInt('userId', response.userId);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MyHomePage(title: '홈'),
          ),
        );
      }
    } catch (e) {
      logger.d('카카오 로그인 실패: $e');

      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
      if (scaffoldMessenger != null) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
        );
      }
    }
  }
}
