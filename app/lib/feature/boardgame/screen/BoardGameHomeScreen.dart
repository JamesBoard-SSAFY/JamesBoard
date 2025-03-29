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
  void onImageTap(String id) {
    // id로 수행할 작업을 여기에 작성
    print('Image $id clicked!');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BoardGameDetailScreen()),
    );
  }

  List<String> makeImageUrlOrder() {
    List<String> shuffledList = List.from(AppDummyData.imageUrls);
    shuffledList.shuffle();
    return shuffledList;
  }

  void updateFilter(String key, String value) {
    setState(() {
      AppDummyData.selectedFilters[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppDummyData.imageUrls.shuffle();

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
              imageUrls: makeImageUrlOrder(), // 섞인 이미지 URL 리스트
              title: title, // 각 제목을 전달
              updateFilter: updateFilter,
              updateCategory: AppString.genre,
              selectedFilters: AppDummyData.selectedFilters,
            );
          }),
          ListTopTenGame(
            imageUrls: AppDummyData.imageUrls,
            title: AppString.agentTop,
            onImageTap: onImageTap,
          ),
          ...AppDummyData.numOfPersonTitles.map((title) {
            return ListHomeHorizontalGame(
              imageUrls: makeImageUrlOrder(), // 섞인 이미지 URL 리스트
              title: title, // 각 제목을 전달
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
              imageUrls: makeImageUrlOrder(), // 섞인 이미지 URL 리스트
              title: title, // 각 제목을 전달
              updateFilter: updateFilter,
              updateCategory: AppString.level,
              selectedFilters: AppDummyData.selectedFilters,
            );
          }),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
