import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/feature/login/screen/LoginScreen.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/main.dart';

import '../../feature/login/viewmodel/LoginViewModel.dart';
import '../../feature/survey/screen/SurveyCategoryScreen.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;

  const SplashScreen({super.key, required this.isLoggedIn});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _navigate() async {
    if (widget.isLoggedIn) {
      final loginViewModel =
          Provider.of<LoginViewModel>(context, listen: false);

      // storage 에서 userId 읽기
      final userIdString = await storage.read(key: AppString.keyUserId);
      final userId = int.tryParse(userIdString ?? '');

      if (userId == null) {
        // 에러 처리: 로그인은 됐지만 userId 가 없으면 로그인 화면으로
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
        return;
      }

      // preferBoardGameId 확인
      final preferBoardGameId =
          await loginViewModel.checkUserPreferBoardGame(userId);

      if (!mounted) return;

      if (preferBoardGameId == -1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SurveyCategoryScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const MyHome(title: AppString.homeAppBarTitle)),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainWhite,
      body: Center(
        child: Lottie.asset('assets/image/splash_screen_animation.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain, onLoaded: (composition) {
          _navigate();
        }),
      ),
    );
  }
}
