import 'package:flutter/material.dart';
import 'package:jamesboard/feature/boardgame/widget/appbar/MyPageAppBar.dart';
import 'package:jamesboard/feature/login/viewmodel/LoginViewModel.dart';
import 'package:jamesboard/repository/LoginRepository.dart';

import '../feature/boardgame/widget/appbar/HomeAppBar.dart';
import '../feature/boardgame/widget/appbar/ListAppBar.dart';

class AppBarUtil {
  static PreferredSizeWidget? getAppBar(int selectedIndex) {
    final loginViewModel = LoginViewModel(LoginRepository.create());

    switch (selectedIndex) {
      case 0: // 홈
        return HomeAppBar(title: "JamesBoard");
      case 1: // 검색 (검색 바가 있는 AppBar)
        return ListAppBar(title: "요원님을 위한 맞춤 업무");
      case 2: // 프로필 (AppBar가 없음)
        return null;
      case 3: // 프로필 (AppBar가 없음)
        return ListAppBar(title: "임무 보고 아카이브");
      default:
        return MyPageAppBar(
          title: "요원 로그",
          loginViewModel: loginViewModel,
        );
    }
  }
}
