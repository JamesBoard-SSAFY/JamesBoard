import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/feature/boardgame/screen/ListBoardGameCategoryPage.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/widget/appbar/DefaultCommonAppBar.dart';

class ListBoardGameCategory extends StatelessWidget {
  final Function(String, String) updateFilter;
  final String title;
  final String updateCategory;
  final Map<String, dynamic> queryParameters;

  const ListBoardGameCategory({
    required this.updateFilter,
    required this.title,
    required this.updateCategory,
    required this.queryParameters,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      appBar: DefaultCommonAppBar(title: AppString.listBoardCategoryTitle),
      body: ListBoardGameCategoryPage(
        title: title,
        updateFilter: updateFilter,
        updateCategory: updateCategory,
        queryParameters: queryParameters,
      ),
    );
  }
}
