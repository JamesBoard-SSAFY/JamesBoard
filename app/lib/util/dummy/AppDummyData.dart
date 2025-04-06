import 'dart:ui';

import 'package:jamesboard/constants/AppString.dart';

import '../../feature/chatbot/screen/ChatBotScreen.dart';
import '../../feature/user/widget/chart/ChartUserGenrePercent.dart';
import '../CommonUtils.dart';

class AppDummyData {
  // 이미지 리스트 예시
  static final List<Map<String, String>> images = [
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

  //mission
  static final List<String> imageAssets = [
    'assets/image/mission1.png',
    'assets/image/mission2.png',
    'assets/image/mission3.png',
    'assets/image/mission4.png',
    'assets/image/mission5.png',
    'assets/image/mission6.png',
    'assets/image/mission7.png',
    'assets/image/mission8.png',
    'assets/image/mission1.png',
    'assets/image/mission2.png',
    'assets/image/mission3.png',
    'assets/image/mission4.png',
    'assets/image/mission5.png',
    'assets/image/mission6.png',
    'assets/image/mission7.png',
    'assets/image/mission8.png',
    'assets/image/mission1.png',
    'assets/image/mission2.png',
    'assets/image/mission3.png',
    'assets/image/mission4.png',
    'assets/image/mission5.png',
    'assets/image/mission6.png',
    'assets/image/mission7.png',
    'assets/image/mission8.png',
  ];

  //chatbot
  static final List<ChatMessage> messages = [
    ChatMessage(
      message: '요원 hyuun, Q입니다. 임무 계획 수립을 위해 다음 정보를 한 번에 전달해 주시기 바랍니다.',
      isMe: false,
      time: '오전 08:13',
    ),
    ChatMessage(
      message: '장르, 참여 인원, 난이도, 게임당 플레이 시간 등 이 정보를 바탕으로, 최적화 보드게임 작전을 준비하겠습니다.',
      isMe: false,
      time: '오전 08:14',
    ),
  ];

  // 이미지 URL 리스트
  static final List<String> imageUrls = [
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
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
    'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
    'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
    'https://cf.geekdo-images.com/7SrPNGBKg9IIsP4UQpOi8g__original/img/GKueTbkCk2Ramf6ai8mDj-BP6cI=/0x0/filters:format(jpeg)/pic4325841.jpg',
    'https://cf.geekdo-images.com/5CFwjd8zTcGYVUnkXh04hw__original/img/N8btACZrnEYK1amBNk26VBdcGwc=/0x0/filters:format(jpeg)/pic1176894.jpg',
  ];

  // Mypage
  static final List<Map<String, String>> missionReportimages = [
    {
      'id': '1',
      'img':
          'https://cf.geekdo-images.com/rpwCZAjYLD940NWwP3SRoA__thumb/img/YT6svCVsWqLrDitcMEtyazVktbQ=/fit-in/200x150/filters:strip_icc()/pic4718279.jpg'
    },
    {
      'id': '2',
      'img':
          'https://cf.geekdo-images.com/o9-sNXmFS_TLAb7ZlZ4dRA__thumb/img/22MSUC0-ZWgwzhi_VKIbENJik1w=/fit-in/200x150/filters:strip_icc()/pic3211873.jpg'
    },
    {
      'id': '3',
      'img':
          'https://cf.geekdo-images.com/FfguJeknahk88vKT7C3JLA__thumb/img/cpf23VxElZxuYaIGcgrjPn80sZY=/fit-in/200x150/filters:strip_icc()/pic7376875.jpg'
    },
    {
      'id': '4',
      'img':
          'https://cf.geekdo-images.com/8SADtu_4zBH_UJrCo935Iw__thumb/img/vwTEQOWA3Mw__ztkTMulOgJ82Pw=/fit-in/200x150/filters:strip_icc()/pic6348964.jpg'
    },
    {
      'id': '5',
      'img':
          'https://cf.geekdo-images.com/k7lG683LBZdvFyS-FH-MpA__thumb/img/6KTtiknxxGwd0ARKrlsdoXFtHfI=/fit-in/200x150/filters:strip_icc()/pic6746812.png'
    },
    {
      'id': '6',
      'img':
          'https://cf.geekdo-images.com/PyUol9QxBnZQCJqZI6bmSA__thumb/img/virV2Bm82Dql7gh-LZScBwqByik=/fit-in/200x150/filters:strip_icc()/pic8632666.png'
    },
    {
      'id': '7',
      'img':
          'https://cf.geekdo-images.com/eJx8hRJ6-86C2VrhECwEPA__thumb/img/J1PlqFqtN-hxuXM4eEi-ekANPP4=/fit-in/200x150/filters:strip_icc()/pic1000553.jpg'
    },
    {
      'id': '8',
      'img':
          'https://cf.geekdo-images.com/nMitZr9Lu4Ux7LLqBy7Z8A__thumb/img/mLHWOFfdxrWljImkFZ2ulIhHt7A=/fit-in/200x150/filters:strip_icc()/pic6875169.png'
    },
    {
      'id': '9',
      'img':
          'https://cf.geekdo-images.com/soAzNVWglCdVBacNjoCTJw__thumb/img/0UPEyOaSFyqEH1ikrSig_218RQ0=/fit-in/200x150/filters:strip_icc()/pic2338267.jpg'
    },
    {
      'id': '10',
      'img':
          'https://cf.geekdo-images.com/wX4cTWNjTG7XiGHGgSpiiw__thumb/img/vU6kaL3f06BaVfmwUV91trrvDng=/fit-in/200x150/filters:strip_icc()/pic8630033.png'
    },
    {
      'id': '11',
      'img':
          'https://cf.geekdo-images.com/iif2Nv17Vhw8puN2bATaaw__thumb/img/GtXKwk8tJkmHtUvWPT2FIabXh0w=/fit-in/200x150/filters:strip_icc()/pic7794273.png'
    },
    {
      'id': '12',
      'img':
          'https://cf.geekdo-images.com/o23NBqu_LBRAtRaVoOBBhQ__thumb/img/VEXGKhNHkULY2hJ41r4Agob5RvE=/fit-in/200x150/filters:strip_icc()/pic403442.jpg'
    },
    {
      'id': '13',
      'img':
          'https://cf.geekdo-images.com/AL5D-dXabY-Lk3PqIFk_0g__thumb/img/Q-76aN92M3OveMp26t7b0i7V-i4=/fit-in/200x150/filters:strip_icc()/pic4597095.jpg'
    },
    {
      'id': '14',
      'img':
          'https://cf.geekdo-images.com/3qg1xTP7ZZiu8OolGBYJ1w__thumb/img/2LGbUy0Hen-8-8bQ-ZfwHjNnCtU=/fit-in/200x150/filters:strip_icc()/pic1766273.jpg'
    },
    {
      'id': '15',
      'img':
          'https://cf.geekdo-images.com/ajU3xzGDUKihjNdvjCR1Hw__thumb/img/pXR57sUMEJ-GJydf-yyAu0ZLgZw=/fit-in/200x150/filters:strip_icc()/pic3328391.jpg'
    },
  ];

  static final List<Map<String, dynamic>> missionStatisticsGenres = [
    {
      'genre': '전략',
      'percent': 25,
      'count': 33,
      'color': CommonUtils.getGenreColor('전략')
    },
    {
      'genre': '파티',
      'percent': 22,
      'count': 100,
      'color': CommonUtils.getGenreColor('파티')
    },
    {
      'genre': '추리',
      'percent': 19,
      'count': 95,
      'color': CommonUtils.getGenreColor('추리')
    },
    {
      'genre': '경제',
      'percent': 17.5,
      'count': 80,
      'color': CommonUtils.getGenreColor('경제')
    },
    {
      'genre': '모험',
      'percent': 16.5,
      'count': 70,
      'color': CommonUtils.getGenreColor('모험')
    },
    {
      'genre': '전쟁',
      'percent': 0,
      'count': 0,
      'color': CommonUtils.getGenreColor('전쟁')
    },
  ];

  // static final List<ChartData> missionStatisticsChartData =
  //     missionStatisticsGenres.map((genre) {
  //   {'genre': '전략', 'percent': 25, 'count': 33, 'color': CommonUtils.getGenreColor('전략')},
  //   {'genre': '파티', 'percent': 22, 'count': 100, 'color': CommonUtils.getGenreColor('파티')},
  //   {'genre': '추리', 'percent': 19, 'count': 95, 'color': CommonUtils.getGenreColor('추리')},
  //   {'genre': '경제', 'percent': 17.5, 'count': 80, 'color': CommonUtils.getGenreColor('경제')},
  //   {'genre': '모험', 'percent': 16.5, 'count': 70, 'color': CommonUtils.getGenreColor('모험')},
  //   {'genre': '전쟁', 'percent': 25, 'count': 0, 'color': CommonUtils.getGenreColor('전쟁')},
  // ];

  static final List<ChartData> missionStatisticsChartData =
      missionStatisticsGenres.map((genre) {
    return ChartData(
      genre['genre'] as String,
      (genre['percent'] as num).toDouble(),
      genre['color'] as Color,
    );
  }).toList();

  static final List<Map<String, String>> missionCumulativeGameData = [
    {
      'id': '1',
      'img':
          'https://cf.geekdo-images.com/rpwCZAjYLD940NWwP3SRoA__thumb/img/YT6svCVsWqLrDitcMEtyazVktbQ=/fit-in/200x150/filters:strip_icc()/pic4718279.jpg',
      'title': '디 마허',
      'round': '35',
    },
    {
      'id': '2',
      'img':
          'https://cf.geekdo-images.com/o9-sNXmFS_TLAb7ZlZ4dRA__thumb/img/22MSUC0-ZWgwzhi_VKIbENJik1w=/fit-in/200x150/filters:strip_icc()/pic3211873.jpg',
      'title': '사무라이',
      'round': '35',
    },
    {
      'id': '3',
      'img':
          'https://cf.geekdo-images.com/FfguJeknahk88vKT7C3JLA__thumb/img/cpf23VxElZxuYaIGcgrjPn80sZY=/fit-in/200x150/filters:strip_icc()/pic7376875.jpg',
      'title': '어콰이어',
      'round': '35',
    },
    {
      'id': '4',
      'img':
          'https://cf.geekdo-images.com/8SADtu_4zBH_UJrCo935Iw__thumb/img/vwTEQOWA3Mw__ztkTMulOgJ82Pw=/fit-in/200x150/filters:strip_icc()/pic6348964.jpg',
      'title': '보난자',
      'round': '35',
    },
    {
      'id': '5',
      'img':
          'https://cf.geekdo-images.com/k7lG683LBZdvFyS-FH-MpA__thumb/img/6KTtiknxxGwd0ARKrlsdoXFtHfI=/fit-in/200x150/filters:strip_icc()/pic6746812.png',
      'title': '라',
      'round': '35',
    },
    {
      'id': '6',
      'img':
          'https://cf.geekdo-images.com/PyUol9QxBnZQCJqZI6bmSA__thumb/img/virV2Bm82Dql7gh-LZScBwqByik=/fit-in/200x150/filters:strip_icc()/pic8632666.png',
      'title': '카탄',
      'round': '35',
    },
    {
      'id': '7',
      'img':
          'https://cf.geekdo-images.com/eJx8hRJ6-86C2VrhECwEPA__thumb/img/J1PlqFqtN-hxuXM4eEi-ekANPP4=/fit-in/200x150/filters:strip_icc()/pic1000553.jpg',
      'title': '로보랠리',
      'round': '35',
    },
    {
      'id': '8',
      'img':
          'https://cf.geekdo-images.com/nMitZr9Lu4Ux7LLqBy7Z8A__thumb/img/mLHWOFfdxrWljImkFZ2ulIhHt7A=/fit-in/200x150/filters:strip_icc()/pic6875169.png',
      'title': '디 마허',
      'round': '35',
    },
    {
      'id': '9',
      'img':
          'https://cf.geekdo-images.com/soAzNVWglCdVBacNjoCTJw__thumb/img/0UPEyOaSFyqEH1ikrSig_218RQ0=/fit-in/200x150/filters:strip_icc()/pic2338267.jpg',
      'title': '멈출 수 없어',
      'round': '35',
    },
    {
      'id': '10',
      'img':
          'https://cf.geekdo-images.com/wX4cTWNjTG7XiGHGgSpiiw__thumb/img/vU6kaL3f06BaVfmwUV91trrvDng=/fit-in/200x150/filters:strip_icc()/pic8630033.png',
      'title': '티그리스 & 유프라테스',
      'round': '35',
    }
  ];

  //MissionRecordScreen
  static final Map<String, dynamic> missionReportGameData = {
    "gameTitle": "다빈치 코드",
    "gameImage":
        "https://cf.geekdo-images.com/rpwCZAjYLD940NWwP3SRoA__original/img/yR0aoBVKNrAmmCuBeSzQnMflLYg=/0x0/filters:format(jpeg)/pic4718279.jpg",
    "gameCategoryList": ["전략", "추리"],
    "minAge": 15,
    "gameYear": 1997,
    "minPlayer": 2,
    "maxPlayer": 4,
    "difficulty": 2,
    "playTime": 45,
    "archiveList": [
      {
        "archiveId": 101,
        "createdAt": "2025-03-10",
        "archiveContent": "친구들과 플레이했는데 너무 재미있었어요!",
        "archiveGamePlayCount": 3,
        "archiveImage":
            "https://cf.geekdo-images.com/PyUol9QxBnZQCJqZI6bmSA__original/img/g11AF48C6pLizxWPAq9dUEeKltQ=/0x0/filters:format(png)/pic8632666.png"
      },
      {
        "archiveId": 102,
        "createdAt": "2024-12-15",
        "archiveContent": "가족과 함께 플레이하면서 전략적인 부분을 많이 배웠어요.",
        "archiveGamePlayCount": 5,
        "archiveImage":
            "https://cf.geekdo-images.com/o9-sNXmFS_TLAb7ZlZ4dRA__original/img/TPKZgpNxB_C73RNbhKyP6UR76X0=/0x0/filters:format(jpeg)/pic3211873.jpg"
      },
      {
        "archiveId": 103,
        "createdAt": "2023-07-08",
        "archiveContent": "처음 해봤는데 규칙이 쉬워서 금방 적응할 수 있었어요.",
        "archiveGamePlayCount": 2,
        "archiveImage":
            "https://cf.geekdo-images.com/FfguJeknahk88vKT7C3JLA__original/img/9xV86q5SLQAJtOsr0KKw5G6UOMM=/0x0/filters:format(jpeg)/pic7376875.jpg"
      },
      {
        "archiveId": 104,
        "createdAt": "2025-03-20",
        "archiveContent": "2025-03-20오랜만에 다시 해보니 새로운 전략을 발견했어요.",
        "archiveGamePlayCount": 4,
        "archiveImage":
            "https://cf.geekdo-images.com/8SADtu_4zBH_UJrCo935Iw__original/img/RNuAr2CDbxE3XzeJVkxj4Df3eVM=/0x0/filters:format(jpeg)/pic6348964.jpg"
      },
      {
        "archiveId": 105,
        "createdAt": "2025-07-20",
        "archiveContent": "2025-07-20오랜만에 다시 해보니 새로운 전략을 발견했어요.",
        "archiveGamePlayCount": 4,
        "archiveImage":
            "https://cf.geekdo-images.com/8SADtu_4zBH_UJrCo935Iw__original/img/RNuAr2CDbxE3XzeJVkxj4Df3eVM=/0x0/filters:format(jpeg)/pic6348964.jpg"
      },
    ]
  };
  // static final Map<String, dynamic> missionReportGameData = {
  //   "id": 1,
  //   'name': '클루',
  //   'img': 'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
  //   'minAge': 15,
  //   'year': 1997,
  //   'minPlayer': 2,
  //   'maxPlayer': 4,
  //   'difficulty': 1,
  //   'playTime': 40,
  //   'genre': ['추리', '전략'],
  // };
  // static final Map<String, dynamic> missionData = {
  //   'img': 'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
  //   'content': '무심한 듯하지만 디테일은 확실한.  3시간 40분동안 클루 보드게임에 푹 빠져, 시간 가는 줄 몰랐던 그 특별한 순간.',
  //   'tag': 3,
  //   'date': "2025-03-10",
  // };

  static final List<Map<String, String>> surveyImages = [
    {'id': '1', 'img': 'assets/image/survey_category_party.jpg', 'name': '파티'},
    {
      'id': '2',
      'img': 'assets/image/survey_category_strategy.jpg',
      'name': '전략'
    },
    {
      'id': '3',
      'img': 'assets/image/survey_category_economy.jpg',
      'name': '경제'
    },
    {
      'id': '4',
      'img': 'assets/image/survey_category_adventure.jpg',
      'name': '모험'
    },
    {
      'id': '5',
      'img': 'assets/image/survey_category_role_playing.jpg',
      'name': '롤플레잉'
    },
    {'id': '6', 'img': 'assets/image/survey_category_family.jpg', 'name': '가족'},
    {'id': '7', 'img': 'assets/image/survey_category_reason.jpg', 'name': '추리'},
    {'id': '8', 'img': 'assets/image/survey_category_war.jpg', 'name': '전쟁'},
    {
      'id': '9',
      'img': 'assets/image/survey_category_abstract_strategy.jpg',
      'name': '추상전략'
    },
  ];

  static final List<Map<String, dynamic>> gameList = [
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
  ];

  static final List<String> filters = [
    AppString.keyCategory,
    AppString.keyMinPlayers,
    AppString.keyDifficulty,
    AppString.keyPlayTime
  ];

  static final Map<String, String> filterButtonMap = {
    AppString.keyCategory: AppString.filterGenre,
    AppString.keyMinPlayers: AppString.filterNumOfPersons,
    AppString.keyDifficulty: AppString.filterDifficulty,
    AppString.keyPlayTime: AppString.filterAvgGameTime
  };

  static final Map<String, String> filterQueryKeyMap = {
    AppString.filterGenre: AppString.keyCategory,
    AppString.filterNumOfPersons: AppString.keyMinPlayers,
    AppString.filterDifficulty: AppString.keyDifficulty,
    AppString.filterAvgGameTime: AppString.keyPlayTime
  };

  static final Map<String, List<String>> filterOptions = {
    AppString.keyCategory: [
      AppString.categoryParty,
      AppString.categoryStrategy,
      AppString.categoryEconomy,
      AppString.categoryAdventure,
      AppString.categoryRolePlaying,
      AppString.categoryFamily,
      AppString.categoryDeduction,
      AppString.categoryWar,
      AppString.categoryAbstractStrategy,
      AppString.categoryAny,
    ],
    AppString.keyMinPlayers: [
      AppString.playersSolo,
      AppString.playersDuo,
      AppString.playersTeam,
      AppString.playersAssemble,
      AppString.playersAny,
    ],
    AppString.keyDifficulty: [
      AppString.difficultyBeginner,
      AppString.difficultyIntermediate,
      AppString.difficultyAdvanced,
      AppString.difficultyAny,
    ],
    AppString.keyPlayTime: [
      AppString.playtimeUltraShort,
      AppString.playtimeShort,
      AppString.playtimeMedium,
      AppString.playtimeLong,
      AppString.playtimeAny,
    ],
  };

  // 필터 매핑
  static final Map<String, String> filterDisplayMap = {
    AppString.playersSolo: AppString.playersSoloValue,
    AppString.playersDuo: AppString.playersDuoValue,
    AppString.playersTeam: AppString.playersTeamValue,
    AppString.playersAssemble: AppString.playersAssembleValue,
    AppString.playtimeUltraShort: AppString.playtimeUltraShortValue,
    AppString.playtimeShort: AppString.playtimeShortValue,
    AppString.playtimeMedium: AppString.playtimeMediumValue,
    AppString.playtimeLong: AppString.playtimeLongValue,
    AppString.difficultyBeginner: AppString.difficultyBeginnerValue,
    AppString.difficultyIntermediate: AppString.difficultyIntermediateValue,
    AppString.difficultyAdvanced: AppString.difficultyAdvancedValue,
    AppString.difficultyAny: AppString.difficultyAnyValue,
    AppString.categoryParty: AppString.categoryPartyValue,
    AppString.categoryStrategy: AppString.categoryStrategyValue,
    AppString.categoryEconomy: AppString.categoryEconomyValue,
    AppString.categoryAdventure: AppString.categoryAdventureValue,
    AppString.categoryRolePlaying: AppString.categoryRolePlayingValue,
    AppString.categoryFamily: AppString.categoryFamilyValue,
    AppString.categoryDeduction: AppString.categoryDeductionValue,
    AppString.categoryWar: AppString.categoryWarValue,
    AppString.categoryAbstractStrategy: AppString.categoryAbstractStrategyValue,
    AppString.categoryAny: AppString.categoryAnyValue,
  };

  static const Map<String, String> categoryMap = {
    AppString.categoryParty: AppString.categoryParty,
    AppString.categoryStrategy: AppString.categoryStrategy,
    AppString.categoryEconomy: AppString.categoryEconomy,
    AppString.categoryAdventure: AppString.categoryAdventure,
    AppString.categoryRolePlayingValue: AppString.categoryRolePlayingValue,
    AppString.categoryFamily: AppString.categoryFamily,
    AppString.categoryDeduction: AppString.categoryDeductionValue,
    AppString.categoryWar: AppString.categoryWar,
    AppString.categoryAbstractStrategy: AppString.categoryAbstractStrategyValue,
    AppString.categoryAny: AppString.categoryAny,
  };

  static const Map<String, int> difficultyMap = {
    AppString.difficultyBeginner: 0,
    AppString.difficultyIntermediate: 1,
    AppString.difficultyAdvanced: 2,
  };

  static const Map<int, String> difficultyStrMap = {
    0: AppString.difficultyBeginner,
    1: AppString.difficultyIntermediate,
    2: AppString.difficultyAdvanced,
  };

  static const Map<String, int> minPlayersMap = {
    AppString.playersSolo: 1,
    AppString.playersDuo: 2,
    AppString.playersTeam: 3,
    AppString.playersAssemble: 5,
  };

  static const Map<int, String> minPlayerStrMap = {
    1: AppString.playersSolo,
    2: AppString.playersDuo,
    3: AppString.playersTeam,
    5: AppString.playersAssemble,
  };

  static const Map<String, List<int>> playTimeMap = {
    AppString.playtimeUltraShort: [0, 30],
    AppString.playtimeShort: [60, 120],
    AppString.playtimeMedium: [120, 240],
    AppString.playtimeLong: [240, 9999],
  };

  static Map<String, String> selectedFilters = {
    AppString.filterGenre: AppString.filterGenre,
    AppString.filterNumOfPersons: AppString.filterNumOfPersons,
    AppString.filterDifficulty: AppString.filterDifficulty,
    AppString.filterAvgGameTime: AppString.filterAvgGameTime
  };
}
