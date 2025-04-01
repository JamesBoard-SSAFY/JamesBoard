import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../constants/AppString.dart';
import '../constants/FontString.dart';
import '../datasource/model/response/BoardGameDetailResponse.dart';
import '../feature/boardgame/widget/BottomSheetBoardGameDetailDetail.dart';
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
        return BottomSheetBoardGameDetailDetail(
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
        );
      },
    );
  }

  static void showRatingBottomSheet(BuildContext context,
      {required int gameId}) async {
    String userIdStr = await storage.read(key: 'userId') ?? '';

    int userId = int.parse(userIdStr);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BottomSheetBoardGameEvaluation(
          gameId: gameId,
          userId: userId,
        );
      },
    );
  }
}
