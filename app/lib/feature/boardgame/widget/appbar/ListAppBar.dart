import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

class ListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const ListAppBar({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: mainBlack,
      elevation: 0,
      title: Text(
          title,
          style: TextStyle(
              fontSize: 22,
              color: mainWhite,
              fontFamily: 'PretendardSemiBold'
          )
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
