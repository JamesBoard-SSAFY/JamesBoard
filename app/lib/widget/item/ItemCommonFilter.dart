import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // flutter_svg 패키지 추가
import 'package:jamesboard/theme/Colors.dart';

class ItemCommonFilter extends StatelessWidget {
  final String title;
  final String checkIconPath;
  final bool isSelected;
  final VoidCallback onTap; // 부모에게 선택 상태를 알리기 위한 콜백 속성

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
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1),
        decoration: BoxDecoration(
          color: secondaryBlack,
          borderRadius: BorderRadius.circular(4),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'PretendardSemiBold',
              color: isSelected ? mainGold : mainGrey,
            ),
          ),
          trailing: isSelected
              ? SvgPicture.asset(
            checkIconPath, // SVG 체크 아이콘
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
