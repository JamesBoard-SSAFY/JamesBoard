import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/feature/boardgame/viewmodel/BoardGameViewModel.dart';
import 'package:jamesboard/feature/boardgame/viewmodel/UserActivityViewModel.dart';
import 'package:provider/provider.dart';

import '../../../constants/FontString.dart';
import '../../../datasource/model/request/user/UserActivityPatchRequest.dart';
import '../../../datasource/model/request/user/UserActivityRequest.dart';
import '../../../main.dart';
import '../../../theme/Colors.dart';
import '../viewmodel/CategoryGameViewModel.dart';
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
  late BoardGameViewModel ratingBoardGameViewModel;
  late UserActivityViewModel viewModel;

  double _rating = 0.0;

  void _updateRating(double rating) {
    setState(() {
      _rating = rating;
    });
  }

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<UserActivityViewModel>(context, listen: false);
    final categoryViewModel =
        Provider.of<CategoryGameViewModel>(context, listen: false);
    ratingBoardGameViewModel =
        categoryViewModel.getCategoryViewModel("${widget.gameId}rating");
  }

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
              AppString.rating,
              style: TextStyle(
                color: mainWhite,
                fontSize: 20,
                fontFamily: FontString.pretendardBold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          RatingBarBoardGameDetailReview(
            initialRating: _rating,
            onRatingUpdate: (rating) {
              _updateRating(rating);
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
              onPressed: () async {
                if (_rating == 0.0) {
                  logger.d("rating $_rating");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppString.selectRating,
                      ),
                    ),
                  );
                  return;
                }

                final userActivityId = await viewModel.checkUserActivity(
                  userId: widget.userId,
                  gameId: widget.gameId,
                );

                final isRatingExists = userActivityId > 0;

                if (isRatingExists) {
                  final request = UserActivityPatchRequest(
                    rating: _rating,
                  );

                  final success = await viewModel.updateUserActivityRating(
                    userActivityId: userActivityId,
                    request: request,
                  );

                  logger.d("updateUserActivityRating update success $success");

                  if (success) {
                    ratingBoardGameViewModel.getBoardGameDetail(widget.gameId);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppString.notPatchRating,
                        ),
                      ),
                    );
                  }
                } else {
                  final request = UserActivityRequest(
                    gameId: widget.gameId,
                    userId: widget.userId,
                    rating: _rating,
                  );

                  final success = await viewModel.addUserActivity(request);

                  logger.d("updateUserActivityRating write success $success");

                  if (success) {
                    ratingBoardGameViewModel.getBoardGameDetail(widget.gameId);
                    Navigator.of(context).pop(); // 성공 시 바텀시트 닫기
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppString.notPostRating,
                        ),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryBlack,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: Text(
                AppString.apply,
                style: TextStyle(
                  color: mainWhite,
                  fontSize: 16,
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
