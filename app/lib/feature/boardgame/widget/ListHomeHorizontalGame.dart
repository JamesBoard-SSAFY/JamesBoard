import 'package:flutter/material.dart';
import 'package:jamesboard/feature/boardgame/screen/ListBoardGameCategory.dart';

import '../../../theme/Colors.dart';
import '../../../widget/image/ImageCommonGameCard.dart';

class ListHomeHorizontalGame extends StatelessWidget {
  final List<String> imageUrls;
  final String title;
  final String updateCategory;
  final Function(String, String) updateFilter;
  final Map<String, String> selectedFilters;

  const ListHomeHorizontalGame(
      {Key? key,
      required this.imageUrls,
      required this.title,
      required this.updateCategory,
      required this.updateFilter,
      required this.selectedFilters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32, left: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListBoardGameCategory(
                          title: title,
                          updateCategory: updateCategory,
                          updateFilter: updateFilter,
                          selectedFilters: selectedFilters,
                        )),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'PretendardMedium',
                    color: mainWhite,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: mainWhite,
                  size: 32,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 160, // ListView의 높이를 지정
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // 가로 스크롤 설정
              itemCount: 10, // 아이템 개수
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 8.0), // 오른쪽에만 마진을 추가
                  child: ImageCommonGameCard(
                    imageUrl: imageUrls[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
