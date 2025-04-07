import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/feature/login/screen/LoginScreen.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/main.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;

  const SplashScreen({super.key, required this.isLoggedIn});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainWhite,
      body: Center(
        child: Lottie.asset('assets/image/splash_screen_animation.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain, onLoaded: (composition) {
          Future.delayed(composition.duration, () {
            // 로그인 된 상태라면
            if (widget.isLoggedIn) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const MyHome(title: AppString.homeAppBarTitle),
                ),
              );
            }
            // 로그인 되지 않은 상태라면
            else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            }
          });
        }),
      ),
    );
  }
}
