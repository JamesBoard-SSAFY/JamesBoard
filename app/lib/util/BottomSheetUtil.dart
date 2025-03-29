import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../constants/AppString.dart';
import '../constants/FontString.dart';
import '../feature/boardgame/widget/BottomSheetBoardGameDetailDetail.dart';
import '../feature/boardgame/widget/BottomSheetBoardGameEvaluation.dart';
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BottomSheetBoardGameEvaluation();
      },
    );
  }
}
