import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/feature/chatbot/screen/ChatBotScreen.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../../../../constants/FontString.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const HomeAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: mainBlack,
      elevation: 0,
      title: Text(title,
          style: TextStyle(
              fontSize: 22,
              color: mainWhite,
              fontFamily: FontString.pretendardSemiBold)),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            IconPath.chat, // 🔹 SVG 아이콘 적용
            width: 24, // 아이콘 크기 조정
            height: 24,
            colorFilter:
                ColorFilter.mode(mainWhite, BlendMode.srcIn), // 🔹 색상 변경
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChatBotScreen(title: AppString.chatbotAppBarTitle),
              ),
            );
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            IconPath.search, // 🔹 다른 SVG 아이콘 추가
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
