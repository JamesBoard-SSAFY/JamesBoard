import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/feature/boardgame/widget/ListBGGRankGame.dart';
import 'package:jamesboard/feature/boardgame/widget/ListHomeHorizontalGame.dart';
import 'package:jamesboard/feature/boardgame/widget/ListTopTenGame.dart';
import 'package:jamesboard/util/dummy/AppDummyData.dart';
import 'package:jamesboard/util/view/KeepAliveView.dart';
import '../widget/CardHomeSuggestion.dart';
import 'BoardGameDetailScreen.dart';

class BoardGameHomeScreen extends StatefulWidget {
  const BoardGameHomeScreen({super.key});

  @override
  State<BoardGameHomeScreen> createState() => _BoardGameHomeScreenState();
}

class _BoardGameHomeScreenState extends State<BoardGameHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  void onImageTap(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoardGameDetailScreen(
          gameId: id,
        ),
      ),
    );
  }

  void updateFilter(String key, String value) {
    setState(() {
      AppDummyData.selectedFilters[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      CardHomeSuggestion(
        images: AppDummyData.images,
        onImageTap: onImageTap,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'category': '파티',
        },
        title: '파티 : 요원들의 은밀한 모임!',
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'category': '전략',
        },
        title: '전략 : 첩보 전략의 결정판!',
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'category': '경제',
        },
        title: '경제 : 부의 흐름을 추적하라!',
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'category': '모험',
        },
        title: '모험 : 위험과 비밀의 세계!',
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'category': '롤플레잉',
        },
        title: '롤플레잉 : 위장하고 기만하라!',
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'category': '가족',
        },
        title: '가족 : 웃음과 전략을 함께!',
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'category': '추리',
        },
        title: '추리 : 단서로 배신자를 밝혀라!',
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'category': '전쟁',
        },
        title: '전쟁 : 긴장 속 최후의 승자!',
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'category': '추상 전략',
        },
        title: '추상전략 : 냉철한 전략으로 승부!',
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListTopTenGame(
        queryParameters: {'sortBy': 'game_avg_rating'},
        title: AppString.agentTop,
        onImageTap: onImageTap,
        imageUrls: AppDummyData.imageUrls,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'minPlayers': 1,
        },
        title: 'Solo Mission : 1명',
        updateFilter: updateFilter,
        updateCategory: AppString.numOfPerson,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'minPlayers': 2,
        },
        title: 'Duo Mission : 2명',
        updateFilter: updateFilter,
        updateCategory: AppString.numOfPerson,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'minPlayers': 3,
        },
        title: 'Team Mission : 3 ~ 4명',
        updateFilter: updateFilter,
        updateCategory: AppString.numOfPerson,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'minPlayers': 5,
        },
        title: 'Assemble Mission : 5인 이상',
        updateFilter: updateFilter,
        updateCategory: AppString.numOfPerson,
      ),
      ListBGGRankGame(
        queryParameters: {'sortBy': 'game_rank'},
        imageUrls: AppDummyData.imageUrls,
        title: AppString.bggRank,
        onImageTap: onImageTap,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'difficulty': 0,
        },
        title: '임무 난이도 : 초급',
        updateFilter: updateFilter,
        updateCategory: AppString.level,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'difficulty': 1,
        },
        title: '임무 난이도 : 중급',
        updateFilter: updateFilter,
        updateCategory: AppString.level,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          'difficulty': 2,
        },
        title: '임무 난이도 : 고급',
        updateFilter: updateFilter,
        updateCategory: AppString.level,
      ),
      SizedBox(height: 20),
    ];

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return KeepAliveView(
          child: items[index],
        );
      },
    );
  }
}
