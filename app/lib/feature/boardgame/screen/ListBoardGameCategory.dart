import 'package:flutter/material.dart';
import 'package:jamesboard/feature/boardgame/screen/ListBoardGameCategoryPage.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/widget/appbar/DefaultCommonAppBar.dart';

class ListBoardGameCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      appBar: DefaultCommonAppBar(title: "전체임무보기"),
      body: ListBoardGameCategoryPage()
    );
  }
}