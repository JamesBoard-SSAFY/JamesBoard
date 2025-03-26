import 'package:flutter/material.dart';

import '../../../theme/Colors.dart';
import '../../../widget/image/ImageCommonGameCard.dart';

class ListHomeHorizontalGame extends StatelessWidget {
  final List<String> imageUrls; // 게임 이미지 URL 리스트
  final String title; // 섹션 제목

  const ListHomeHorizontalGame({
    Key? key,
    required this.imageUrls,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32, left: 20),
      child: Column(
        children: [
          Row(
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
          SizedBox(height: 16),
          SizedBox(
            height: 160, // ListView의 높이를 지정
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // 가로 스크롤 설정
              itemCount: 10, // 아이템 개수
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 8.0),  // 오른쪽에만 마진을 추가
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
