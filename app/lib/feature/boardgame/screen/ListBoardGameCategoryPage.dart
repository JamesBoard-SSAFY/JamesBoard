import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';
import '../../../widget/button/ButtonCommonFilter.dart';
import '../../../widget/bottomsheet/BottomSheetCommonFilter.dart';
import '../../../widget/image/ImageCommonGameCard.dart';

class ListBoardGameCategoryPage extends StatefulWidget {
  const ListBoardGameCategoryPage({super.key});

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

  Map<String, String> selectedFilters = {
    '장르': '장르',
    '인원': '인원',
    '난이도': '난이도',
    '평균 게임 시간': '평균 게임 시간'
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

  void _showFilterBottomSheet(String filterType) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetCommonFilter(
        items: filterOptions[filterType]!,
        initialValue: selectedFilters[filterType] != filterType
            ? selectedFilters[filterType]
            : null,
      ),
    );

    if (result != null) {
      setState(() {
        selectedFilters[filterType] = result == '상관없음' ? filterType : result;
      });
    }
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
                  ...selectedFilters.keys.map((filterType) {
                    return Container(
                      margin: EdgeInsets.only(right: 16),
                      child: ButtonCommonFilter(
                        text: filterDisplayMap[selectedFilters[filterType]] ??
                            selectedFilters[filterType]!,
                        isSelected: selectedFilters[filterType] != filterType,
                        onTap: () => _showFilterBottomSheet(filterType),
                      ),
                    );
                  }),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilters.updateAll((key, value) => key);
                      });
                    },
                    child: Text(
                      '초기화',
                      style: TextStyle(
                        color: mainWhite,
                        fontSize: 16,
                        fontFamily: 'PretendardSemiBold',
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
