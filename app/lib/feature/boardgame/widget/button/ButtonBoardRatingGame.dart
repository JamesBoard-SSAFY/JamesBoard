import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/CommonUtils.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/BoardGameViewModel.dart';
import '../../viewmodel/CategoryGameViewModel.dart';

class ButtonBoardRatingGame extends StatefulWidget {
  final int gameId;
  final double rating;
  final VoidCallback? onPressed;
  final bool disableWithOpacity;
  final bool hasUserRated;

  const ButtonBoardRatingGame({
    super.key,
    required this.gameId,
    required this.rating,
    required this.onPressed,
    required this.disableWithOpacity,
    required this.hasUserRated,
  });

  @override
  State<ButtonBoardRatingGame> createState() => _ButtonBoardRatingGameState();
}

class _ButtonBoardRatingGameState extends State<ButtonBoardRatingGame> {
  late BoardGameViewModel ratingViewModel;

  @override
  void initState() {
    super.initState();

    final categoryViewModel =
        Provider.of<CategoryGameViewModel>(context, listen: false);
    ratingViewModel =
        categoryViewModel.getCategoryViewModel("${widget.gameId}rating");
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;

    return ChangeNotifierProvider.value(
      value: ratingViewModel,
      child: Opacity(
        opacity: isDisabled && widget.disableWithOpacity ? 0.4 : 1.0,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: IntrinsicHeight(
            child: AbsorbPointer(
              absorbing: isDisabled && widget.disableWithOpacity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onPressed!();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: secondaryBlack,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                // build 메서드 안의 Consumer 부분만 수정
                child: Consumer<BoardGameViewModel>(
                  builder: (context, viewModel, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppString.evaluation,
                          style: TextStyle(
                            color: mainWhite,
                            fontSize: 16,
                            fontFamily: FontString.pretendardBold,
                          ),
                        ),
                        const SizedBox(width: 4), // 간격
                        Text(
                          "(${CommonUtils.roundToTwoDecimalPlaces(
                            viewModel.boardGameDetail?.gameRating ??
                                widget.rating,
                          )})",
                          style: TextStyle(
                            color: mainGold,
                            fontSize: 16,
                            fontFamily: FontString.pretendardBold,
                          ),
                        ),
                        const SizedBox(width: 6), // 텍스트와 아이콘 사이 간격
                        SvgPicture.asset(
                          IconPath.starSelected,
                          width: 14,
                          height: 14,
                          colorFilter: ColorFilter.mode(
                            widget.hasUserRated ? mainGold : mainGrey,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
