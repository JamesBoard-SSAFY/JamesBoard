import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';

class RatingBoardGameDetail extends StatelessWidget {
  final double rating;

  const RatingBoardGameDetail({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          IconPath.starSelected,
          width: 24,
          height: 24,
          color: mainGold,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          '$rating',
          style: TextStyle(
              color: mainGold,
              fontSize: 16,
              fontFamily: FontString.pretendardMedium),
        )
      ],
    );
  }
}
