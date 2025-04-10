import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../constants/AppString.dart';
import '../constants/FontString.dart';
import '../datasource/model/response/BoardGameDetailResponse.dart';
import '../feature/boardgame/widget/BottomSheetBoardGameDetail.dart';
import '../feature/boardgame/widget/BottomSheetBoardGameEvaluation.dart';
import '../feature/boardgame/widget/RatingBarBoardGameDetailReview.dart';
import '../main.dart';

class BottomSheetUtil {
  static void showBoardGameDetailBottomSheet(BuildContext context,
      {required BoardGameDetailResponse boardGameDetail}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          // 최소 높이
          maxChildSize: 0.9,
          // 최대 높이
          expand: false,
          builder: (context, scrollController) {
            return BottomSheetBoardGameDetail(
              gameId: boardGameDetail.gameId,
              gameTitle: boardGameDetail.gameTitle,
              gameReleaseYear: boardGameDetail.gameYear,
              gameCategories: boardGameDetail.gameCategories,
              gameThemes: boardGameDetail.gameThemes,
              gameAverageRating: boardGameDetail.gameRating,
              gameDifficulty: boardGameDetail.difficulty,
              gameAge: boardGameDetail.gameMinAge,
              gameMinPlayer: boardGameDetail.minPlayers,
              gameMaxPlayer: boardGameDetail.maxPlayers,
              gamePlayTime: boardGameDetail.playTime,
              gameDescription: boardGameDetail.description,
              gamePublisher: boardGameDetail.gamePublisher,
              gameDesigners: boardGameDetail.gameDesigners,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  // showRatingBottomSheet 내부에서 변경
  static Future<double?> showRatingBottomSheet(
    BuildContext context, {
    required int gameId,
    required double myRating,
  }) async {
    String userIdStr = await storage.read(key: 'userId') ?? '';
    int userId = int.parse(userIdStr);

    final updatedRating = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BottomSheetBoardGameEvaluation(
          gameId: gameId,
          userId: userId,
          myRating: myRating,
        );
      },
    );

    return updatedRating;
  }
}
