import '../../feature/chatbot/screen/ChatBotScreen.dart';

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

  static Map<String, String> titleCategoryMap = {
    '파티 : 요원들의 은밀한 모임!': '파티',
    '전략 : 첩보 전략의 결정판!': '전략',
    "경제 : 부의 흐름을 추적하라!": "경제",
    "모험 : 위험과 비밀의 세계!": "모험",
    "롤플레잉 : 위장하고 기만하라!": "롤플레잉",
    "가족 : 웃음과 전략을 함께!": "가족",
    "추리 : 단서로 배신자를 밝혀라!": "추리",
    "전쟁 : 긴장 속 최후의 승자!": "전쟁",
    "추상전략 : 냉철한 전략으로 승부!": "추상 전략"
  };

  static final List<String> numOfPersonTitles = [
    "Solo Mission : 1명",
    "Duo Mission : 2명",
    "Team Mission : 3 ~ 4명",
    "Assemble Mission : 5인 이상",
  ];

  static final Map<String, int> gamePersonMap = {
    'Solo Mission : 1명': 1,
    'Duo Mission : 2명': 2,
    'Team Mission : 3 ~ 4명': 3,
    'Assemble Mission : 5인 이상': 5,
  };

  static final List<String> missionLevelTitles = [
    "임무 난이도 : 초급",
    "임무 난이도 : 중급",
    "임무 난이도 : 고급",
  ];

  static final Map<String, int> missionLevelMap = {
    "임무 난이도 : 초급": 0,
    "임무 난이도 : 중급": 1,
    "임무 난이도 : 고급": 2,
  };

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
    // 추가 게임 데이터
  ];
}
