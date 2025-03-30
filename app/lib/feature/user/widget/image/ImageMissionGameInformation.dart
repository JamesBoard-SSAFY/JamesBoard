import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../../../../widget/button/ButtonCommonGameTag.dart';

class ImageMissionGameInformation extends StatelessWidget {
  final Map<String, dynamic> gameData;

  const ImageMissionGameInformation({
    super.key,
    required this.gameData,
  });

  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 0:
        return '초급';
      case 1:
        return '중급';
      case 2:
        return '고급';
      default:
        return '알 수 없음';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageHeight = screenWidth / 2;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomLeft, // 텍스트를 좌측 하단 정렬
          children: [
            // 배경 이미지
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                gameData["gameImage"] ?? '',
                width: screenWidth,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 20,
              bottom: 12,
              child: Container(
                child: Text(
                  gameData["gameTitle"] ?? '',
                  style: TextStyle(
                    color: mainWhite,
                    fontSize: 44,
                    fontFamily: FontString.pretendardBold,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: 8.0, // 항목 간의 수평 간격
            runSpacing: 8.0, // 줄바꿈 시 항목 간의 수직 간격
            children: [
              ButtonCommonGameTag(text: '${gameData["minAge"]}세'),
              ButtonCommonGameTag(text: '${gameData["gameYear"]}년'),
              ButtonCommonGameTag(
                  text: _getDifficultyText(gameData["difficulty"])),
              ButtonCommonGameTag(
                  text: '${gameData["minPlayer"]} ~ ${gameData["maxPlayer"]}명'),
              ButtonCommonGameTag(text: '${gameData["playTime"]}분'),
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                gameData["gameCategoryList"].join(' · '),
                style: TextStyle(
                  color: mainGrey,
                  fontSize: 16,
                  fontFamily: FontString.pretendardMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
