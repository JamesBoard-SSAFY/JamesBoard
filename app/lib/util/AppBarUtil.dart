import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/feature/boardgame/widget/appbar/MyPageAppBar.dart';
import 'package:jamesboard/feature/login/viewmodel/LoginViewModel.dart';
import 'package:jamesboard/repository/LoginRepository.dart';
import 'package:jamesboard/repository/UserRepository.dart';

import '../feature/boardgame/widget/appbar/HomeAppBar.dart';
import '../feature/boardgame/widget/appbar/ListAppBar.dart';

class AppBarUtil {
  static PreferredSizeWidget? getAppBar(int selectedIndex) {
    final loginViewModel = LoginViewModel(
      LoginRepository.create(),
      UserRepository.create(),
    );

    switch (selectedIndex) {
      case 0: // 홈
        return HomeAppBar(title: AppString.homeAppBarTitle);
      case 1: // 검색 (검색 바가 있는 AppBar)
        return ListAppBar(title: AppString.recommendAppBarTitle);
      case 2: // 프로필 (AppBar가 없음)
        return null;
      case 3: // 프로필 (AppBar가 없음)
        return ListAppBar(title: AppString.missionAppBarTitle);
      default:
        return MyPageAppBar(
          title: AppString.myPageAppBarTitle,
          loginViewModel: loginViewModel,
        );
    }
  }
}
