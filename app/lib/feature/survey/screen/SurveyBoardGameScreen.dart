import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../../../constants/FontString.dart';
import '../../../widget/button/ButtonCommonPrimaryBottom.dart';
import '../widget/ButtonSurveyBoardGameName.dart';

class SurveyBoardGameScreen extends StatefulWidget {
  final String selectedBoardGameId;

  const SurveyBoardGameScreen({super.key, required this.selectedBoardGameId});

  @override
  State<SurveyBoardGameScreen> createState() => _SurveyBoardGameScreenState();
}

class _SurveyBoardGameScreenState extends State<SurveyBoardGameScreen> {
  String? selectedGameId;

  final List<Map<String, dynamic>> games = [
    {'gameId': 1, 'gameTitle': '카탄'},
    {'gameId': 2, 'gameTitle': '티켓 투 라이드'},
    {'gameId': 3, 'gameTitle': '팬데믹'},
    {'gameId': 4, 'gameTitle': '아그리콜라'},
    {'gameId': 5, 'gameTitle': '다 마허'},
    {'gameId': 6, 'gameTitle': '사무라이'},
    {'gameId': 7, 'gameTitle': '어콰이어'},
    {'gameId': 8, 'gameTitle': '보난자'},
    {'gameId': 9, 'gameTitle': '라'},
    {'gameId': 10, 'gameTitle': '로보랠리'},
    {'gameId': 11, 'gameTitle': '팬데믹'},
    {'gameId': 12, 'gameTitle': '아그리콜라'},
    {'gameId': 13, 'gameTitle': '카탄'},
    {'gameId': 14, 'gameTitle': '티켓 투 라이드'},
    {'gameId': 15, 'gameTitle': '팬데믹'},
    {'gameId': 16, 'gameTitle': '아그리콜라'},
    {'gameId': 17, 'gameTitle': '카탄'},
    {'gameId': 18, 'gameTitle': '티켓 투 라이드'},
    {'gameId': 19, 'gameTitle': '팬데믹'},
    {'gameId': 20, 'gameTitle': '아그리콜라'},
    {'gameId': 21, 'gameTitle': '카탄'},
    {'gameId': 22, 'gameTitle': '티켓 투 라이드'},
    {'gameId': 23, 'gameTitle': '팬데믹'},
    {'gameId': 24, 'gameTitle': '아그리콜라'},
    {'gameId': 25, 'gameTitle': '카탄'},
    {'gameId': 26, 'gameTitle': '티켓 투 라이드'},
    {'gameId': 27, 'gameTitle': '팬데믹'},
    {'gameId': 28, 'gameTitle': '아그리콜라'},
    {'gameId': 29, 'gameTitle': '카탄'},
    {'gameId': 30, 'gameTitle': '티켓 투 라이드'},
  ];

  @override
  Widget build(BuildContext context) {
    String getCategoryName() {
      switch (widget.selectedBoardGameId) {
        case '1':
          return '파티';
        case '2':
          return '전략';
        case '3':
          return '경제';
        case '4':
          return '모험';
        case '5':
          return '롤플레잉';
        case '6':
          return '가족';
        case '7':
          return '추리';
        case '8':
          return '전쟁';
        case '9':
          return '추상전략';
        default:
          return '아무거나';
      }
    }

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
                      text: getCategoryName(),
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
                  final gameId = game['gameId'].toString();
                  final gameTitle = game['gameTitle'] as String;
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 32,
        ),
        child: ButtonCommonPrimaryBottom(
          text: '선택',
          onPressed: () {},
        ),
      ),
    );
  }
}
