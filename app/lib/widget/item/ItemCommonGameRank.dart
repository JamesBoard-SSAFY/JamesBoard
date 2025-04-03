import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../../datasource/model/response/MyPage/TopPlayedGame.dart';

class ItemCommonGameRank extends StatelessWidget {
  final List<TopPlayedGame> gameData;

  const ItemCommonGameRank({super.key, required this.gameData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: gameData.asMap().entries.map((entry) {
        final index = entry.key;
        final game = entry.value;

        return GestureDetector(
          onTap: () {
            print("게임 ID: ${game.gameId} 클릭됨"); // 클릭 이벤트
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: secondaryBlack,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ListTile(
                  leading: ClipOval(
                    child: Image.network(
                      game.gameImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    game.gameTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: FontString.pretendardSemiBold,
                      color: mainWhite,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // 초과 시 ... 표시
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/image/icon_time.svg',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "${game.totalPlayCount}판",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: FontString.pretendardSemiBold,
                          color: mainWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: -20,
                  bottom: -20,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '${index + 1}', // index + 1로 순위 표시
                          style: TextStyle(
                            fontSize: 50,
                            fontFamily: FontString.pretendardSemiBold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = mainGold,
                          ),
                        ),
                        Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 50,
                            fontFamily: FontString.pretendardSemiBold,
                            color: mainRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
