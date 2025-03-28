import 'package:flutter/material.dart';
import 'package:jamesboard/feature/login/viewmodel/LoginViewModel.dart';
import 'package:jamesboard/repository/LoginRepository.dart';
import '../widget/CardLoginExplanation.dart';
import '../widget/KakaoLoginButton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final viewModel = LoginViewModel(LoginRepository.create());
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
          KakaoLoginButton(onPressed: () async {
            await viewModel.login(context);
          }),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
