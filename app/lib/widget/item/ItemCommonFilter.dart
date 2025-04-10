import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/constants/FontString.dart';

import '../../theme/Colors.dart';

class ItemCommonFilter extends StatelessWidget {
  final String title;
  final String checkIconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const ItemCommonFilter({
    super.key,
    required this.title,
    required this.checkIconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontFamily: FontString.pretendardSemiBold,
              color: isSelected ? mainGold : mainGrey,
            ),
          ),
          trailing: isSelected
              ? SvgPicture.asset(
                  checkIconPath,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(mainGold, BlendMode.srcIn),
                )
              : null,
        ),
      ),
    );
  }
}
