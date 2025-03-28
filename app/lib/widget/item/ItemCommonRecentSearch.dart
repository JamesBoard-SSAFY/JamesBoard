import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // flutter_svg 패키지 추가
import 'package:jamesboard/theme/Colors.dart';

import '../../constants/FontString.dart';

class ItemCommonRecentSearch extends StatefulWidget {
  final String title;
  final String iconPath;

  const ItemCommonRecentSearch(
      {super.key, required this.title, required this.iconPath});

  @override
  State<ItemCommonRecentSearch> createState() => _ItemCommonRecentSearchState();
}

class _ItemCommonRecentSearchState extends State<ItemCommonRecentSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.5),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          widget.title,
          style: TextStyle(
              fontSize: 18,
              fontFamily: FontString.pretendardSemiBold,
              color: mainWhite),
        ),
        trailing: SvgPicture.asset(
          widget.iconPath, // SVG 체크 아이콘
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn),
        ),
      ),
    );
  }
}
