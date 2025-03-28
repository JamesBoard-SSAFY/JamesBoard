import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/Colors.dart';

class CommonUtils {
  // 시간을 '오전 08:13' 형식으로 반환하는 메소드
  static String formatTime(DateTime currentTime) {
    // 'a'는 'AM/PM'을 반환하므로, 이를 한국어로 변환
    String formattedTime = DateFormat('a hh:mm').format(currentTime);

    // 'AM'은 '오전', 'PM'은 '오후'로 변환
    formattedTime = formattedTime.replaceFirst('AM', '오전').replaceFirst('PM', '오후');

    return formattedTime;
  }

  // 장르에 맞는 색상을 반환하는 메소드
  static Color getGenreColor(String genre) {
    switch (genre) {
      case '전략':
        return mainStrategy;
      case '파티':
        return mainParty;
      case '추리':
        return mainReasoning;
      case '경제':
        return mainEconomy;
      case '모험':
        return mainAdventure;
      case '롤플레잉':
        return mainRolePlaying;
      case '가족':
        return mainFamily;
      case '전쟁':
        return mainWar;
      case '추상전략':
        return mainAbstractStrategy;
      default:
        return Colors.black; // 기본 색상 (알 수 없는 장르에 대한 색상)
    }
  }
}