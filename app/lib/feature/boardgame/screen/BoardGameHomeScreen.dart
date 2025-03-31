import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/feature/boardgame/widget/ListBGGRankGame.dart';
import 'package:jamesboard/feature/boardgame/widget/ListHomeHorizontalGame.dart';
import 'package:jamesboard/feature/boardgame/widget/ListTopTenGame.dart';
import 'package:jamesboard/util/dummy/AppDummyData.dart';
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

  void onImageTap(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BoardGameDetailScreen()),
    );
  }

  void updateFilter(String key, String value) {
    setState(() {
      AppDummyData.selectedFilters[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: CardHomeSuggestion(
              images: AppDummyData.images,
              onImageTap: onImageTap,
            ),
          ),
          ...AppDummyData.genreTitles.map((title) {
            return ListHomeHorizontalGame(
              queryParameters: {
                'category': AppDummyData.titleCategoryMap[title],
              },
              title: title,
              updateFilter: updateFilter,
              updateCategory: AppString.genre,
              selectedFilters: AppDummyData.selectedFilters,
            );
          }),
          ListTopTenGame(
            title: AppString.agentTop,
            onImageTap: onImageTap,
            imageUrls: AppDummyData.imageUrls,
          ),
          ...AppDummyData.numOfPersonTitles.map((numTitle) {
            return ListHomeHorizontalGame(
              queryParameters: {
                'minPlayers': AppDummyData.gamePersonMap[numTitle],
              },
              title: numTitle,
              updateFilter: updateFilter,
              updateCategory: AppString.numOfPerson,
              selectedFilters: AppDummyData.selectedFilters,
            );
          }),
          ListBGGRankGame(
            imageUrls: AppDummyData.imageUrls,
            title: AppString.bggRank,
            onImageTap: onImageTap,
          ),
          ...AppDummyData.missionLevelTitles.map((title) {
            return ListHomeHorizontalGame(
              queryParameters: {
                'difficulty': AppDummyData.missionLevelMap[title],
              },
              title: title,
              updateFilter: updateFilter,
              updateCategory: AppString.level,
              selectedFilters: AppDummyData.selectedFilters,
            );
          }),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
