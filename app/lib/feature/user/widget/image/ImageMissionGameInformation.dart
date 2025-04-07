import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:marquee/marquee.dart';
import '../../../../datasource/model/response/MyPage/MyPageMissionRecordResponse.dart';
import '../../../../widget/button/ButtonCommonGameTag.dart';

class ImageMissionGameInformation extends StatelessWidget {
  final MyPageMissionRecordResponse gameData;

  const ImageMissionGameInformation({
    super.key,
    required this.gameData,
  });

  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 0:
        return AppString.difficultyBeginnerValue;
      case 1:
        return AppString.difficultyIntermediateValue;
      case 2:
        return AppString.difficultyUnKnownValue;
      default:
        return AppString.difficultyAnyValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageHeight = MediaQuery.of(context).size.height * 0.35;

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
              child: gameData.gameImage != null &&
                      gameData.gameImage!.startsWith('http')
                  ? Image.network(
                      gameData.gameImage!,
                      width: screenWidth,
                      height: imageHeight,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: screenWidth,
                      height: imageHeight,
                      color: mainBlack,
                    ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent, // 위쪽은 투명
                      shadowBlack.withOpacity(0.8), // 아래로 갈수록 진하게
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final text = gameData.gameTitle ?? '';
                      final textStyle = TextStyle(
                        color: mainWhite,
                        fontSize: 44,
                        fontFamily: FontString.pretendardBold,
                      );

                      final textPainter = TextPainter(
                        text: TextSpan(text: text, style: textStyle),
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      )..layout(maxWidth: double.infinity);

                      final textWidth = textPainter.size.width;
                      final availableWidth = constraints.maxWidth - 40; // 패딩 고려

                      final shouldScroll = textWidth > availableWidth;

                      return Container(
                        width: screenWidth,
                        height: 60,
                        alignment: Alignment.centerLeft,
                        child: shouldScroll
                            ? Marquee(
                                text: text,
                                scrollAxis: Axis.horizontal,
                                velocity: 30.0,
                                blankSpace: 50.0,
                                style: textStyle,
                              )
                            : Text(
                                text,
                                style: textStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                      );
                    },
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
              ButtonCommonGameTag(text: '${gameData.minAge}세'),
              ButtonCommonGameTag(text: '${gameData.gameYear}년'),
              ButtonCommonGameTag(
                  text: _getDifficultyText(gameData.difficulty)),
              ButtonCommonGameTag(
                  text: '${gameData.minPlayer} ~ ${gameData.maxPlayer}명'),
              ButtonCommonGameTag(text: '${gameData.playTime}분'),
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
                gameData.gameCategoryList.join(' · '),
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
