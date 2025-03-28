import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/feature/boardgame/widget/ListBGGRankGame.dart';
import 'package:jamesboard/feature/boardgame/widget/ListHomeHorizontalGame.dart';
import 'package:jamesboard/feature/boardgame/widget/ListTopTenGame.dart';

import '../widget/CardHomeSuggestion.dart';

class BoardGameHomeScreen extends StatefulWidget {
  const BoardGameHomeScreen({super.key});

  @override
  State<BoardGameHomeScreen> createState() => _BoardGameHomeScreenState();
}

class _BoardGameHomeScreenState extends State<BoardGameHomeScreen> {
  // 이미지 리스트 예시
  final List<Map<String, String>> images = [
    {
      'id': '1',
      'url':
          'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg'
    },
    {
      'id': '2',
      'url':
          'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg'
    },
    {
      'id': '3',
      'url':
          'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg'
    },
    {
      'id': '4',
      'url':
          'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg'
    },
    {
      'id': '5',
      'url':
          'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg'
    },
    {
      'id': '6',
      'url':
          'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg'
    },
    {
      'id': '7',
      'url':
          'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg'
    },
    {
      'id': '8',
      'url':
          'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg'
    },
    {
      'id': '9',
      'url':
          'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg'
    },
  ];

  // 이미지 URL 리스트
  final List<String> imageUrls = [
    'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
    'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
    'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
  ];

  final List<String> genreTitles = [
    "파티 : 요원들의 은밀한 모임!",
    "전략 : 첩보 전략의 결정판!",
    "경제 : 부의 흐름을 추적하라!",
    "모험 : 위험과 비밀의 세계!",
    "롤플레잉 : 위장하고 기만하라!",
    "가족 : 웃음과 전략을 함께!",
    "추리 : 단서로 배신자를 밝혀라!",
    "전쟁 : 긴장 속 최후의 승자!",
    "추상전략 : 냉철한 전략으로 승부!"
  ];

  final List<String> numOfPersonTitles = [
    "Solo Mission : 1명",
    "Duo Mission : 2명",
    "Team Mission : 3 ~ 4명",
    "Assemble Mission : 5인 이상",
  ];

  final List<String> missionLevelTitles = [
    "임무 난이도 : 초급",
    "임무 난이도 : 중급",
    "임무 난이도 : 고급",
  ];

  // 이미지 클릭 시 수행할 작업
  void onImageTap(String id) {
    // id로 수행할 작업을 여기에 작성
    print('Image $id clicked!');
  }

  List<String> makeImageUrlOrder() {
    List<String> shuffledList = List.from(imageUrls);
    shuffledList.shuffle();
    return shuffledList;
  }

  Map<String, String> selectedFilters = {
    '장르': '장르',
    '인원': '인원',
    '난이도': '난이도',
    '평균 게임 시간': '평균 게임 시간'
  };

  void updateFilter(String key, String value) {
    setState(() {
      selectedFilters[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    imageUrls.shuffle();

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: CardHomeSuggestion(
              images: images,
              onImageTap: onImageTap,
            ),
          ),
          ...genreTitles.map((title) {
            return ListHomeHorizontalGame(
              imageUrls: makeImageUrlOrder(), // 섞인 이미지 URL 리스트
              title: title, // 각 제목을 전달
              updateFilter: updateFilter,
              updateCategory: AppString.genre,
              selectedFilters: selectedFilters,
            );
          }),
          ListTopTenGame(imageUrls: imageUrls, title: AppString.agentTop),
          ...numOfPersonTitles.map((title) {
            return ListHomeHorizontalGame(
              imageUrls: makeImageUrlOrder(), // 섞인 이미지 URL 리스트
              title: title, // 각 제목을 전달
              updateFilter: updateFilter,
              updateCategory: AppString.numOfPerson,
              selectedFilters: selectedFilters,
            );
          }),
          ListBGGRankGame(imageUrls: imageUrls, title: AppString.bggRank),
          ...missionLevelTitles.map((title) {
            return ListHomeHorizontalGame(
              imageUrls: makeImageUrlOrder(), // 섞인 이미지 URL 리스트
              title: title, // 각 제목을 전달
              updateFilter: updateFilter,
              updateCategory: AppString.level,
              selectedFilters: selectedFilters,
            );
          }),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
