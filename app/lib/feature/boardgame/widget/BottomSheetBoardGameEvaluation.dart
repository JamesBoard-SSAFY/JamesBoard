import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';

import '../../../constants/FontString.dart';
import '../../../theme/Colors.dart';
import 'RatingBarBoardGameDetailReview.dart';

class BottomSheetBoardGameEvaluation extends StatefulWidget {
  final int gameId;
  final int userId;

  const BottomSheetBoardGameEvaluation({
    super.key,
    required this.gameId,
    required this.userId,
  });

  @override
  State<BottomSheetBoardGameEvaluation> createState() =>
      _BottomSheetBoardGameEvaluationState();
}

class _BottomSheetBoardGameEvaluationState
    extends State<BottomSheetBoardGameEvaluation> {
  @override
  Widget build(BuildContext context) {
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
                AppString.apply,
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
  }
}
