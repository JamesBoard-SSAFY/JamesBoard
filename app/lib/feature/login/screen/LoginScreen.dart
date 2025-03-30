import 'package:flutter/material.dart';
import 'package:jamesboard/feature/login/viewmodel/LoginViewModel.dart';
import 'package:jamesboard/repository/LoginRepository.dart';
import 'package:jamesboard/repository/SurveyRepository.dart';
import 'package:jamesboard/theme/Colors.dart';
import '../widget/CardLoginExplanation.dart';
import '../widget/KakaoLoginButton.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(
        LoginRepository.create(),
        SurveyRepository.create(),
      ),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: mainBlack,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    const Flexible(child: CardLoginExplanation()),
                    if (viewModel.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(
                          color: mainGold,
                        ),
                      )
                    else
                      KakaoLoginButton(
                        onPressed: () async {
                          await viewModel.login(context);
                        },
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
