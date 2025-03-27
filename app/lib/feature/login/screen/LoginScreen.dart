import 'package:flutter/material.dart';
import '../widget/CardLoginExplanation.dart';
import '../widget/KakaoLoginButton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: 32,
          ),
          Flexible(
            child: CardLoginExplanation(),
          ),
          KakaoLoginButton(onPressed: () {}),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
