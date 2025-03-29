import 'package:flutter/material.dart';

import '../widget/ItemRecommendBoardGameInfo.dart';
import 'BoardGameDetailScreen.dart';

class RecommendGameScreen extends StatelessWidget {
  final List<Map<String, dynamic>> gameList = [
    {
      'gameId': 1,
      'imageUrl':
          'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
      'gameName': '클루',
      'gameCategory': '추리',
      'gameTheme': '모험',
      'gameMinPlayer': 2,
      'gameMaxPlayer': 4,
      'gameDifficulty': 1,
      'gamePlayTime': 60,
      'gameDescription':
          '클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다.클루에 대한 설명입니다.클루에 대한 ...',
    },
    {
      'gameId': 2,
      'imageUrl':
          'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
      'gameName': '부루마블',
      'gameCategory': '파티',
      'gameTheme': '추리',
      'gameMinPlayer': 3,
      'gameMaxPlayer': 6,
      'gameDifficulty': 0,
      'gamePlayTime': 45,
      'gameDescription':
          '부루마블에 대한 설명입니다. 부루마블에 대한 설명입니다. 부루마블에 대한 설명입니다. 부루마블에 대한 설명입니다. 부루마블에 대한 설명입니다.클루에 대한 설명입니다.클루에 대한 ...',
    },
    {
      'gameId': 2,
      'imageUrl':
          'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
      'gameName': '클루',
      'gameCategory': '파티',
      'gameTheme': '추리',
      'gameMinPlayer': 3,
      'gameMaxPlayer': 6,
      'gameDifficulty': 0,
      'gamePlayTime': 45,
      'gameDescription':
          '클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다. 클루에 대한 설명입니다.클루에 대한 설명입니다.클루에 대한 ...',
    },
    // 추가 게임 데이터
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: gameList.length,
      itemBuilder: (context, index) {
        final game = gameList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BoardGameDetailScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: ItemRecommendBoardGameInfo(
              gameId: game['gameId'],
              imageUrl: game['imageUrl'],
              gameName: game['gameName'],
              gameCategory: game['gameCategory'],
              gameTheme: game['gameTheme'],
              gameMinPlayer: game['gameMinPlayer'],
              gameMaxPlayer: game['gameMaxPlayer'],
              gameDifficulty: game['gameDifficulty'],
              gamePlayTime: game['gamePlayTime'],
              gameDescription: game['gameDescription'],
            ),
          ),
        );
      },
    );
  }
}
