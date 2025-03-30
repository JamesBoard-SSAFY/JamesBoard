import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/widget/button/ButtonCommonGameTag.dart';

class ItemRecommendBoardGameInfo extends StatelessWidget {
  final int gameId;
  final String imageUrl;
  final String gameName;
  final String gameCategory;
  final int gameMinPlayer;
  final int gameMaxPlayer;
  final int gameDifficulty;
  final int gamePlayTime;
  final String gameDescription;

  const ItemRecommendBoardGameInfo(
      {super.key,
      required this.imageUrl,
      required this.gameName,
      required this.gameCategory,
      required this.gameMinPlayer,
      required this.gameMaxPlayer,
      required this.gameDifficulty,
      required this.gamePlayTime,
      required this.gameDescription,
      required this.gameId});

  // 난이도 변경
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

  // 플레이 시간 변경
  String _getPlayTimeText(int playTime) {
    int hours = playTime ~/ 60;
    int minutes = playTime % 60;

    if (hours > 0) {
      if (minutes > 0) {
        return '$hours시간 $minutes분';
      } else {
        return '$hours시간';
      }
    } else {
      return '$minutes분';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 영역
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Container(
            decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: mainGrey, width: 1),
                  right: BorderSide(color: mainGrey, width: 1),
                  bottom: BorderSide(color: mainGrey, width: 1),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 게임 제목
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
                  child: Text(
                    gameName,
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: FontString.pretendardSemiBold,
                      color: mainWhite,
                    ),
                  ),
                ),

                // 태그 섹션
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Wrap(
                    spacing: 12.0,
                    runSpacing: 8.0,
                    children: [
                      ButtonCommonGameTag(text: gameCategory),
                      // ButtonCommonGameTag(text: gameTheme),
                      ButtonCommonGameTag(
                          text: '$gameMinPlayer ~ $gameMaxPlayer명'),
                      ButtonCommonGameTag(
                          text: _getDifficultyText(gameDifficulty)),
                      ButtonCommonGameTag(text: _getPlayTimeText(gamePlayTime)),
                    ],
                  ),
                ),

                // 설명 섹션
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, top: 16, right: 16, bottom: 20),
                  child: Text(
                    gameDescription,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: FontString.pretendardMedium,
                        color: mainWhite),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
