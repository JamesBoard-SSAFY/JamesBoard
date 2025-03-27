import 'package:flutter/material.dart';
import '../../../widget/button/ButtonCommonFilter.dart';
import '../../../widget/bottomsheet/BottomSheetCommonFilter.dart';

class ListBoardGameCategoryPage extends StatefulWidget {
  const ListBoardGameCategoryPage({super.key});

  @override
  State<ListBoardGameCategoryPage> createState() => _ListBoardGameCategoryPageState();
}

class _ListBoardGameCategoryPageState extends State<ListBoardGameCategoryPage> {
  Map<String, String> selectedFilters = {
    '장르': '장르',
    '인원': '인원',
    '난이도': '난이도',
  };

  final Map<String, List<String>> filterOptions = {
    '장르': ['파티', '전략', '경제', '모험', '롤플레잉', '가족', '추리', '전쟁', '추상전략', '상관없음'],
    '인원': ['Solo: 1인', 'Duo: 2인', 'Team: 3~4인', 'Assemble: 5인 이상', '상관없음'],
    '난이도': ['초급', '중급', '고급', '상관없음'],
  };

  void _showFilterBottomSheet(String filterType) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetCommonFilter(
        items: filterOptions[filterType]!,
        initialValue: selectedFilters[filterType] != filterType ? selectedFilters[filterType] : null,
      ),
    );

    if (result != null) {
      setState(() {
        selectedFilters[filterType] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 20.0,
          children: selectedFilters.keys.map((filterType) {
            return ButtonCommonFilter(
              text: selectedFilters[filterType]!,
              isSelected: selectedFilters[filterType] != filterType,
              onTap: () => _showFilterBottomSheet(filterType),
            );
          }).toList(),
        ),
      ],
    );
  }
}