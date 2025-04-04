import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // flutter_svg 패키지 추가
import 'package:jamesboard/theme/Colors.dart';

import '../../constants/FontString.dart';

class ItemCommonRecentSearch extends StatefulWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ItemCommonRecentSearch({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<ItemCommonRecentSearch> createState() => _ItemCommonRecentSearchState();
}

class _ItemCommonRecentSearchState extends State<ItemCommonRecentSearch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // 전체 클릭
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.5),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: FontString.pretendardSemiBold,
              color: mainWhite,
            ),
          ),
          trailing: GestureDetector(
            onTap: widget.onDelete, // 아이콘 클릭 시 삭제
            child: SvgPicture.asset(
              widget.iconPath,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(mainWhite, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
