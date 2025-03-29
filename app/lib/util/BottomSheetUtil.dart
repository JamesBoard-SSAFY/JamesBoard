import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../constants/AppString.dart';
import '../constants/FontString.dart';
import '../feature/boardgame/widget/BottomSheetBoardGameDetailDetail.dart';
import '../feature/boardgame/widget/RatingBarBoardGameDetailReview.dart';

class BottomSheetUtil {
  static void showBoardGameDetailBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BottomSheetBoardGameDetailDetail(
          gameTitle: '보드게임 이름',
          gameReleaseYear: 2022,
          gameCategories: ['전략', '가족'],
          gameThemes: ['중세', '판타지'],
          gameAverageRating: 8.5,
          gameDifficulty: 1,
          gameAge: 12,
          gameMinPlayer: 2,
          gameMaxPlayer: 4,
          gamePlayTime: 90,
          gameDescription: '이 보드게임은 전략과 재미를 동시에 제공합니다.',
          gamePublisher: 'ABC Games',
          gameDesigners: ['John Doe', 'Jane Doe'],
        );
      },
    );
  }

  static void showRatingBottomSheet(BuildContext context) {
    print("showRatingBottomSheet 호출됨!"); // 디버깅 로그 추가

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        print("BottomSheet builder 실행됨!"); // 디버깅 로그 추가
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.35,
          ),
          decoration: BoxDecoration(
            color: secondaryBlack,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  "클루",
                  style: TextStyle(
                    color: mainWhite,
                    fontSize: 20,
                    fontFamily: FontString.pretendardBold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              RatingBarBoardGameDetailReview(
                initialRating: 0,
                onRatingUpdate: (rating) {
                  print("사용자 평가: $rating");
                },
              ),
              const SizedBox(height: 20),
              // 닫기 버튼
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: mainGrey,
                      width: 1.0,
                    ),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryBlack,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                  ),
                  child: Text(
                    "적용",
                    style: TextStyle(
                      color: mainWhite,
                      fontSize: 20,
                      fontFamily: FontString.pretendardBold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
