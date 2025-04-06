import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/feature/boardgame/widget/ListBGGRankGame.dart';
import 'package:jamesboard/feature/boardgame/widget/ListHomeHorizontalGame.dart';
import 'package:jamesboard/feature/boardgame/widget/ListTopTenGame.dart';
import 'package:jamesboard/util/dummy/AppDummyData.dart';
import 'package:jamesboard/util/view/KeepAliveView.dart';
import '../../../constants/AppData.dart';
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
      AppData.selectedFilters[key] = value;
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
          AppString.keyCategory: AppString.categoryPartyValue,
        },
        title: AppString.categoryPartyTitle,
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          AppString.keyCategory: AppString.categoryStrategyValue,
        },
        title: AppString.categoryStrategyTitle,
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          AppString.keyCategory: AppString.categoryEconomyValue,
        },
        title: AppString.categoryEconomyTitle,
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          AppString.keyCategory: AppString.categoryAdventureValue,
        },
        title: AppString.categoryAdventureTitle,
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          AppString.keyCategory: AppString.categoryRolePlayingValue,
        },
        title: AppString.categoryRolePlayingTitle,
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {AppString.keyCategory: AppString.categoryFamilyValue},
        title: AppString.categoryFamilyTitle,
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          AppString.keyCategory: AppString.categoryDeductionValue
        },
        title: AppString.categoryMysteryTitle,
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {AppString.keyCategory: AppString.categoryWarValue},
        title: AppString.categoryWarTitle,
        updateFilter: updateFilter,
        updateCategory: AppString.genre,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          AppString.keyCategory: AppString.categoryAbstractStrategyValue
        },
        title: AppString.categoryAbstractStrategyTitle,
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
          AppString.keyMinPlayers: AppData.minPlayersMap[AppString.playersSolo],
        },
        title: AppString.numOfPersonSoloTitle,
        updateFilter: updateFilter,
        updateCategory: AppString.numOfPerson,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          AppString.keyMinPlayers: AppData.minPlayersMap[AppString.playersDuo],
        },
        title: AppString.numOfPersonDuoTitle,
        updateFilter: updateFilter,
        updateCategory: AppString.numOfPerson,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          AppString.keyMinPlayers: AppData.minPlayersMap[AppString.playersTeam],
        },
        title: AppString.numOfPersonTeamTitle,
        updateFilter: updateFilter,
        updateCategory: AppString.numOfPerson,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          AppString.keyMinPlayers:
              AppData.minPlayersMap[AppString.playersAssemble],
        },
        title: AppString.numOfPersonAssembleTitle,
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
          AppString.keyDifficulty:
              AppData.difficultyMap[AppString.difficultyBeginner],
        },
        title: AppString.missionLevelBeginnerTitle,
        updateFilter: updateFilter,
        updateCategory: AppString.level,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          AppString.keyDifficulty:
              AppData.difficultyMap[AppString.difficultyIntermediate],
        },
        title: AppString.missionLevelIntermediateTitle,
        updateFilter: updateFilter,
        updateCategory: AppString.level,
      ),
      ListHomeHorizontalGame(
        queryParameters: {
          AppString.keyDifficulty:
              AppData.difficultyMap[AppString.difficultyAdvanced],
        },
        title: AppString.missionLevelAdvancedTitle,
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
