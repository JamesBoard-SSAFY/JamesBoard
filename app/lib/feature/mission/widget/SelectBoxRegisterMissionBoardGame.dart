import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';

class SelectBoxRegisterMissionBoardGame extends StatelessWidget {
  final String? selectedGameTitle;

  const SelectBoxRegisterMissionBoardGame({
    super.key,
    required this.selectedGameTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: secondaryBlack,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedGameTitle ?? AppString.selectBoardGame,
            style: TextStyle(
              color: selectedGameTitle != null ? mainWhite : mainGrey,
              fontSize: 16,
              fontFamily: FontString.pretendardMedium,
            ),
          ),
          SvgPicture.asset(
            IconPath.arrowRight,
            width: 24,
            height: 24,
            color: mainGrey,
          ),
        ],
      ),
    );
  }
}
