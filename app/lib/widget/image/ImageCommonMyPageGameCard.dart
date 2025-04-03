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
      shrinkWrap: true,
      // 부모 위젯의 크기를 따라가도록 설정
      physics: NeverScrollableScrollPhysics(),
      // 스크롤 중첩 방지
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final item = images[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MissionRecordScreen(id: item.gameId),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: item.gameImage != null
                ? Image.network(item.gameImage!, fit: BoxFit.cover)
                : Image.asset('assets/image/sample.png', fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
