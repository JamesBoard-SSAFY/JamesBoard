import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/constants/IconPath.dart';

import 'package:jamesboard/theme/Colors.dart';

import '../../../main.dart';

class RatingBarBoardGameDetailReview extends StatefulWidget {
  final double initialRating;
  final int itemCount;
  final bool allowHalfRating;
  final ValueChanged<double> onRatingUpdate;

  const RatingBarBoardGameDetailReview({
    super.key,
    required this.initialRating,
    this.itemCount = 5,
    this.allowHalfRating = true,
    required this.onRatingUpdate,
  });

  @override
  State<RatingBarBoardGameDetailReview> createState() =>
      _RatingBarBoardGameDetailReviewState();
}

class _RatingBarBoardGameDetailReviewState
    extends State<RatingBarBoardGameDetailReview> {
  @override
  void initState() {
    super.initState();

    logger.d("widget.initialRating : ${widget.initialRating}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      decoration: BoxDecoration(
        color: secondaryBlack,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: RatingBar(
        initialRating: widget.initialRating,
        minRating: 0,
        maxRating: 5,
        allowHalfRating: true,
        itemSize: 48,
        itemPadding: const EdgeInsets.symmetric(
          horizontal: 2,
        ),
        ratingWidget: RatingWidget(
          full: SvgPicture.asset(
            IconPath.starSelected,
            color: mainGold,
          ),
          half: SvgPicture.asset(
            IconPath.starHalfFilled,
          ),
          empty: SvgPicture.asset(
            IconPath.starSelected,
            color: mainGrey,
          ),
        ),
        onRatingUpdate: (rating) {
          widget.onRatingUpdate(rating);
        },
      ),
    );
  }
}
