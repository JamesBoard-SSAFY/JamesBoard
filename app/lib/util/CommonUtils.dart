import 'package:intl/intl.dart';

class CommonUtils {
  // 시간을 '오전 08:13' 형식으로 반환하는 메소드
  static String formatTime(DateTime currentTime) {
    // 'a'는 'AM/PM'을 반환하므로, 이를 한국어로 변환
    String formattedTime = DateFormat('a hh:mm').format(currentTime);

    // 'AM'은 '오전', 'PM'은 '오후'로 변환
    formattedTime = formattedTime.replaceFirst('AM', '오전').replaceFirst('PM', '오후');

    return formattedTime;
  }
}