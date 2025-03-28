import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';
import '../../../widget/button/ButtonCommonFilter.dart';
import '../../../widget/bottomsheet/BottomSheetCommonFilter.dart';
import '../../../widget/image/ImageCommonGameCard.dart';

class ListBoardGameCategoryPage extends StatefulWidget {
  final Function(String, String) updateFilter;
  final String title;
  final String updateCategory;
  final Map<String, String> selectedFilters;

  const ListBoardGameCategoryPage(
      {super.key,
      required this.title,
      required this.updateFilter,
      required this.updateCategory,
      required this.selectedFilters});

  @override
  State<ListBoardGameCategoryPage> createState() =>
      _ListBoardGameCategoryPageState();
}

class _ListBoardGameCategoryPageState extends State<ListBoardGameCategoryPage> {
  final Map<String, String> filterDisplayMap = {
    // 인원 변환
    'Solo: 1인': '1인',
    'Duo: 2인': '2인',
    'Team: 3~4인': '3~4인',
    'Assemble: 5인 이상': '5인 이상',

    // 평균 게임 시간 변환
    '초신속 임무 (0 ~ 30분)': '0 ~ 30분',
    '정밀 작전 (60 ~ 120분)': '60 ~ 120분',
    '장기 작전 (120 ~ 240분)': '120 ~ 240분',
    '마스터 작전 (240분 이상)': '240분 이상',
  };

  final Map<String, List<String>> filterOptions = {
    '장르': ['파티', '전략', '경제', '모험', '롤플레잉', '가족', '추리', '전쟁', '추상전략', '상관없음'],
    '인원': ['Solo: 1인', 'Duo: 2인', 'Team: 3~4인', 'Assemble: 5인 이상', '상관없음'],
    '난이도': ['초급', '중급', '고급', '상관없음'],
    '평균 게임 시간': [
      '초신속 임무 (0 ~ 30분)',
      '정밀 작전 (60 ~ 120분)',
      '장기 작전 (120 ~ 240분)',
      '마스터 작전 (240분 이상)',
      '상관없음'
    ],
  };

  // 이미지 URL 리스트
  final List<String> imageUrls = [
    'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
    'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
    'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
    'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
    'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
  ];

  final Map<String, String> filterTitleMap = {
    // 인원 변환
    '파티 : 요원들의 은밀한 모임!': '파티',
    "전략 : 첩보 전략의 결정판!": '전략',
    "경제 : 부의 흐름을 추적하라!": '경제',
    "모험 : 위험과 비밀의 세계!": '모험',
    "롤플레잉 : 위장하고 기만하라!": '롤플레잉',
    "가족 : 웃음과 전략을 함께!": '가족',
    "추리 : 단서로 배신자를 밝혀라!": '추리',
    "전쟁 : 긴장 속 최후의 승자!": '전쟁',
    "추상전략 : 냉철한 전략으로 승부!": '추상전략',

    "Solo Mission : 1명": '1인',
    "Duo Mission : 2명": '2인',
    "Team Mission : 3 ~ 4명": '3~4인',
    "Assemble Mission : 5인 이상": '5인 이상',

    "임무 난이도 : 초급": '초급',
    "임무 난이도 : 중급": '중급',
    "임무 난이도 : 고급": '고급',
  };

  void _showFilterBottomSheet(String filterType) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetCommonFilter(
        items: filterOptions[filterType]!,
        initialValue: widget.selectedFilters[filterType] != filterType
            ? widget.selectedFilters[filterType]
            : null,
      ),
    );

    if (result != null) {
      widget.updateFilter(
          filterType, result == AppString.noCare ? filterType : result);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    widget.selectedFilters[widget.updateCategory] =
        filterTitleMap[widget.title]!;
  }

  @override
  void dispose() {
    super.dispose();

    widget.selectedFilters.updateAll((key, value) => key);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // 스크롤 가능하도록 감싸줌
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...widget.selectedFilters.keys.map((filterType) {
                    return Container(
                      margin: EdgeInsets.only(right: 16),
                      child: ButtonCommonFilter(
                        text: filterDisplayMap[
                                widget.selectedFilters[filterType]] ??
                            widget.selectedFilters[filterType]!,
                        isSelected:
                            widget.selectedFilters[filterType] != filterType,
                        onTap: () => _showFilterBottomSheet(filterType),
                      ),
                    );
                  }),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.selectedFilters.updateAll((key, value) => key);
                      });
                    },
                    child: Text(
                      AppString.clear,
                      style: TextStyle(
                        color: mainWhite,
                        fontSize: 16,
                        fontFamily: FontString.pretendardSemiBold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 한 줄에 3개
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3 / 4,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return ImageCommonGameCard(
                  imageUrl: imageUrls[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
