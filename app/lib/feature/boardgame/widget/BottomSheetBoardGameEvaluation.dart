import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final double myRating;

  const BottomSheetBoardGameEvaluation({
    super.key,
    required this.gameId,
    required this.userId,
    required this.myRating,
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
  bool isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.myRating;

    viewModel = Provider.of<UserActivityViewModel>(context, listen: false);
    final categoryViewModel =
        Provider.of<CategoryGameViewModel>(context, listen: false);
    ratingBoardGameViewModel =
        categoryViewModel.getCategoryViewModel("${widget.gameId}rating");
  }

  void _updateRating(double rating) {
    setState(() {
      _rating = rating;
    });
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
          const SizedBox(height: 20),
          Text(
            AppString.rating,
            style: TextStyle(
              color: mainWhite,
              fontSize: 20,
              fontFamily: FontString.pretendardBold,
            ),
          ),
          const SizedBox(height: 20),
          RatingBarBoardGameDetailReview(
            initialRating: _rating,
            onRatingUpdate: _updateRating,
          ),
          const SizedBox(height: 20),
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
              onPressed: isButtonDisabled
                  ? null
                  : () async {
                      if (_rating == 0.0) {
                        logger.d("rating $_rating");
                        Fluttertoast.showToast(
                            msg: "0점은 입력이 될 수 없습니다.",
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: const Color(0xff6E6E6E),
                            fontSize: 14,
                            toastLength: Toast.LENGTH_SHORT);
                        return;
                      }

                      setState(() {
                        isButtonDisabled = true; // 버튼 비활성화
                      });

                      final userActivityId = await viewModel.checkUserActivity(
                        userId: widget.userId,
                        gameId: widget.gameId,
                      );

                      final isRatingExists = userActivityId > 0;

                      bool success = false;
                      if (isRatingExists) {
                        final request =
                            UserActivityPatchRequest(rating: _rating);
                        success = await viewModel.updateUserActivityRating(
                          userActivityId: userActivityId,
                          request: request,
                        );
                      } else {
                        final request = UserActivityRequest(
                          gameId: widget.gameId,
                          userId: widget.userId,
                          rating: _rating,
                        );
                        success = await viewModel.addUserActivity(request);
                      }

                      if (success) {
                        ratingBoardGameViewModel
                            .getBoardGameDetail(widget.gameId);
                        Navigator.of(context).pop(_rating); // 별점 반영해서 상위로 전달
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppString.notPatchRating),
                          ),
                        );
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
