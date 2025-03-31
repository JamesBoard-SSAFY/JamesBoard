import 'package:flutter/material.dart';
import 'package:jamesboard/feature/user/screen/MissionRecordScreen.dart';

import '../../datasource/model/response/MyPage/MyPagePlayedGames.dart';

class ImageCommonMyPageGameCard extends StatelessWidget {
  final List<MyPagePlayedGames> images;
  final Function(String id) onTap;

  const ImageCommonMyPageGameCard({
    super.key,
    required this.images,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3x3 그리드
        crossAxisSpacing: 8.0, // 좌우 간격
        mainAxisSpacing: 8.0, // 상하 간격
        childAspectRatio: 1, // 정사각형 비율
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final item = images[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MissionRecordScreen(id: item.gameId),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: item.gameImage != null
                ? Image.network(
              item.gameImage!,
              fit: BoxFit.cover,
            )
                : Image.asset(
              'assets/image/sample.png', // gameImage가 null일 때 에셋 이미지 사용
              fit: BoxFit.cover,
            ),

          ),
        );
      },
    );
  }
}
