import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/datasource/model/request/SurveyBoardGameRequest.dart';
import 'package:jamesboard/datasource/model/response/SurveyBoardGameResponse.dart';
import 'package:jamesboard/feature/survey/viewmodel/SurveyViewModel.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:provider/provider.dart';

import '../../../constants/FontString.dart';
import '../../../widget/button/ButtonCommonPrimaryBottom.dart';
import '../widget/ButtonSurveyBoardGameName.dart';

class SurveyBoardGameScreen extends StatefulWidget {
  final String selectedCategory;

  const SurveyBoardGameScreen({super.key, required this.selectedCategory});

  @override
  State<SurveyBoardGameScreen> createState() => _SurveyBoardGameScreenState();
}

class _SurveyBoardGameScreenState extends State<SurveyBoardGameScreen> {
  int? selectedGameId;
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SurveyViewModel>();
    final games = viewModel.boardGames;

    return Scaffold(
      backgroundColor: mainBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: widget.selectedCategory,
                      style: TextStyle(
                        color: mainGold,
                        fontFamily: FontString.pretendardSemiBold,
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: '에서 가장 마음에 드는\n',
                      style: TextStyle(
                        color: mainWhite,
                        fontFamily: FontString.pretendardSemiBold,
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: '임무를 선택하세요.',
                      style: TextStyle(
                        color: mainWhite,
                        fontFamily: FontString.pretendardSemiBold,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '선택에 따라 당신의 운명이 달라집니다.',
                style: TextStyle(
                  color: mainGrey,
                  fontFamily: FontString.pretendardSemiBold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),

              // 보드게임 리스트
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: games.map((game) {
                  final gameId = game.gameId;
                  final gameTitle = game.gameTitle;
                  final isSelected = selectedGameId == gameId;

                  return ButtonSurveyBoardGameName(
                    text: gameTitle,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        selectedGameId = gameId;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 32,
          ),
          child: ButtonCommonPrimaryBottom(
            text: AppString.register,
            disableWithOpacity: true,
            onPressed: selectedGameId != null && !_isSubmitted
                ? () async {
                    setState(() {
                      _isSubmitted = true;
                    });
                    final userId = await storage.read(key: AppString.keyUserId);

                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(AppString.loginRequired)),
                      );
                      setState(() {
                        _isSubmitted = false;
                      });
                      return;
                    }

                    final request = SurveyBoardGameRequest(
                      gameId: selectedGameId!,
                    );

                    try {
                      final result =
                          await viewModel.insertUserPreferBoardGameSurvey(
                        int.parse(userId),
                        request,
                      );

                      if (result == int.parse(userId)) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MyHome(title: AppString.myHomePageTitle),
                          ),
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(AppString.registrationFailed)),
                        );
                        setState(() {
                          _isSubmitted = false;
                        });
                      }
                    } catch (e) {
                      logger.e('Error during survey submission: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('에러가 발생했습니다. 다시 시도해주세요.')),
                      );
                      setState(() {
                        _isSubmitted = false; // ✅ 에러 시 복구
                      });
                    }
                  }
                : null,
          ),
        ),
      ),
    );
  }
}
