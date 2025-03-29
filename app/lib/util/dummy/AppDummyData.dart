import 'dart:ui';

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

  static final List<String> genreTitles = [
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

  static final List<String> numOfPersonTitles = [
    "Solo Mission : 1명",
    "Duo Mission : 2명",
    "Team Mission : 3 ~ 4명",
    "Assemble Mission : 5인 이상",
  ];

  static final List<String> missionLevelTitles = [
    "임무 난이도 : 초급",
    "임무 난이도 : 중급",
    "임무 난이도 : 고급",
  ];

  static Map<String, String> selectedFilters = {
    '장르': '장르',
    '인원': '인원',
    '난이도': '난이도',
    '평균 게임 시간': '평균 게임 시간'
  };

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

  static final Map<String, String> filterDisplayMap = {
    // 인원 변환
    'Solo: 1인': '1인',
    'Duo: 2인': '2인',
    'Team: 3~4인': '3~4인',
    'Assemble: 5인 이상': '5인 이상',

    // 평균 게임 시간 변환
    '초신속 임무 (0 ~ 30분)': '0 ~ 30분',
    '정밀 작전 (60 ~ 120분)': '60 ~ 120분',
    '장기 작전 (120 ~ 240분)': '120 ~ 240분',
    '마스터 작전 (240분 이상)': '240분 이상',
  };

  static final Map<String, List<String>> filterOptions = {
    '장르': ['파티', '전략', '경제', '모험', '롤플레잉', '가족', '추리', '전쟁', '추상전략', '상관없음'],
    '인원': ['Solo: 1인', 'Duo: 2인', 'Team: 3~4인', 'Assemble: 5인 이상', '상관없음'],
    '난이도': ['초급', '중급', '고급', '상관없음'],
    '평균 게임 시간': [
      '초신속 임무 (0 ~ 30분)',
      '정밀 작전 (60 ~ 120분)',
      '장기 작전 (120 ~ 240분)',
      '마스터 작전 (240분 이상)',
      '상관없음'
    ],
  };

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

  static final Map<String, String> filterTitleMap = {
    // 인원 변환
    '파티 : 요원들의 은밀한 모임!': '파티',
    "전략 : 첩보 전략의 결정판!": '전략',
    "경제 : 부의 흐름을 추적하라!": '경제',
    "모험 : 위험과 비밀의 세계!": '모험',
    "롤플레잉 : 위장하고 기만하라!": '롤플레잉',
    "가족 : 웃음과 전략을 함께!": '가족',
    "추리 : 단서로 배신자를 밝혀라!": '추리',
    "전쟁 : 긴장 속 최후의 승자!": '전쟁',
    "추상전략 : 냉철한 전략으로 승부!": '추상전략',

    "Solo Mission : 1명": '1인',
    "Duo Mission : 2명": '2인',
    "Team Mission : 3 ~ 4명": '3~4인',
    "Assemble Mission : 5인 이상": '5인 이상',

    "임무 난이도 : 초급": '초급',
    "임무 난이도 : 중급": '중급',
    "임무 난이도 : 고급": '고급',
  };

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
    {'genre': '전략', 'percent': 25, 'count': 33, 'color': CommonUtils.getGenreColor('전략')},
    {'genre': '파티', 'percent': 22, 'count': 100, 'color': CommonUtils.getGenreColor('파티')},
    {'genre': '추리', 'percent': 19, 'count': 95, 'color': CommonUtils.getGenreColor('추리')},
    {'genre': '경제', 'percent': 17.5, 'count': 80, 'color': CommonUtils.getGenreColor('경제')},
    {'genre': '모험', 'percent': 16.5, 'count': 70, 'color': CommonUtils.getGenreColor('모험')},
    {'genre': '전쟁', 'percent': 0, 'count': 0, 'color': CommonUtils.getGenreColor('전쟁')},
  ];
  static final List<ChartData> missionStatisticsChartData = missionStatisticsGenres.map((genre) {
    return ChartData(
      genre['genre'] as String,
      (genre['percent'] as num).toDouble(),
      genre['color'] as Color,
      genre['count'] as int, // count 추가
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
    "id": 1,
    'name': '클루',
    'img': 'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
    'minAge': '15',
    'year': '1997',
    'minPlayer': '2',
    'maxPlayer': '4',
    'difficulty': 1,
    'playTime': '40',
    'genre': ['추리', '전략'],
  };
  static final Map<String, dynamic> missionData = {
    'img': 'https://cf.geekdo-images.com/x3zxjr-Vw5iU4yDPg70Jgw__original/img/FpyxH41Y6_ROoePAilPNEhXnzO8=/0x0/filters:format(jpeg)/pic3490053.jpg',
    'content': '무심한 듯하지만 디테일은 확실한.  3시간 40분동안 클루 보드게임에 푹 빠져, 시간 가는 줄 몰랐던 그 특별한 순간.',
    'tag': 3,
    'date': "2025-03-10",
  };

}
