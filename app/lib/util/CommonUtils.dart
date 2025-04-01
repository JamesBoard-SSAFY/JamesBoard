import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../datasource/model/response/MyPage/GenreStats.dart';
import '../datasource/model/response/MyPage/MyPageArchiveResponse.dart';
import '../feature/user/viewmodel/MyPageViewModel.dart';
import '../feature/user/widget/chart/ChartUserGenrePercent.dart';
import '../main.dart';
import '../theme/Colors.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CommonUtils {
  static final ImagePicker _picker = ImagePicker();

  // 시간을 '오전 08:13' 형식으로 반환하는 메소드
  static String formatTime(DateTime currentTime) {
    // 'a'는 'AM/PM'을 반환하므로, 이를 한국어로 변환
    String formattedTime = DateFormat('a hh:mm').format(currentTime);

    // 'AM'은 '오전', 'PM'은 '오후'로 변환
    formattedTime =
        formattedTime.replaceFirst('AM', '오전').replaceFirst('PM', '오후');

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
      case '추상 전략':
        return mainAbstractStrategy;
      default:
        return Colors.black; // 기본 색상 (알 수 없는 장르에 대한 색상)
    }
  }

  // 날짜 문자열에서 "일(day)" 추출 (예: "2025-03-10" → "10")
  static String extractDay(String date) {
    try {
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);
      return parsedDate.day.toString();
    } catch (e) {
      return ''; // 에러 발생 시 빈 문자열 반환
    }
  }

  // 날짜 문자열에서 요일의 첫 글자 반환 (예: "2025-03-10" → "월")
  static String extractDayOfWeek(String date) {
    try {
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);
      List<String> weekDays = ["일", "월", "화", "수", "목", "금", "토"];
      return weekDays[parsedDate.weekday % 7]; // DateTime에서 요일(1=월 ~ 7=일) 변환
    } catch (e) {
      return ''; // 에러 발생 시 빈 문자열 반환
    }
  }

  // 날짜 문자열에서 달 내용 추출
  static String extractMonth(String dateStr) {
    return [
      '1월',
      '2월',
      '3월',
      '4월',
      '5월',
      '6월',
      '7월',
      '8월',
      '9월',
      '10월',
      '11월',
      '12월'
    ][DateTime.parse(dateStr).month - 1];
  }

  // 연도 목록을 추출하는 메서드
  static List<String> extractAvailableYears(
      List<MyPageArchiveResponse> archiveList) {
    Set<String> years = {};
    for (var item in archiveList) {
      String createdAt = item.createdAt; // "2025-03-10" → "2025"
      String year = createdAt.split("-")[0];
      years.add("$year년");
    }
    return years.toList()..sort((a, b) => b.compareTo(a)); // 최신 연도부터 정렬
  }

// 선택된 연도에 대한 월 목록을 추출하는 메서드
  static List<String> extractAvailableMonths(
      List<MyPageArchiveResponse> archiveList, String selectedYear) {
    Set<String> months = {"전체"};
    for (var item in archiveList) {
      String createdAt = item.createdAt;
      List<String> dateParts = createdAt.split("-");
      String year = dateParts[0];
      String month = dateParts[1].replaceFirst(RegExp("^0"), ""); // "03" → "3"

      if ("$year년" == selectedYear) {
        months.add("$month월");
      }
    }
    return months.toList()..sort((a, b) => a.compareTo(b)); // 1월부터 정렬
  }

  // 연도 및 월에 따라 데이터 필터링
  static List<MyPageArchiveResponse> filterArchiveList(
      List<MyPageArchiveResponse> archiveList,
      String selectedYear,
      String selectedMonth) {
    return archiveList.where((item) {
      if (item.createdAt == null) return false;

      DateTime date = DateTime.parse(item.createdAt);
      bool yearMatch = "${date.year}년" == selectedYear;
      bool monthMatch =
          selectedMonth == "전체" || "${date.month}월" == selectedMonth;

      return yearMatch && monthMatch;
    }).toList();
  }

  static List<ChartData> convertGenreStatsToChartData(
      List<GenreStats> genreStats) {
    return genreStats.map((genreInfo) {
      return ChartData(
        genreInfo.gameCategoryName,
        genreInfo.percentage,
        getGenreColor(genreInfo.gameCategoryName),
      );
    }).toList();
  }

  // 이미지 선택 및 WebP 변환 후 S3 업로드
  static Future<String?> pickAndUploadImage(MyPageViewModel viewModel) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String originalFileName = pickedFile.name;
      logger.i("원본 이미지 이름 $originalFileName");
      String newFileName =
          '${path.basenameWithoutExtension(originalFileName)}.webp';
      logger.i("변환 이미지 이름 $newFileName");

      // 이미지 압축 및 WebP 변환
      File? compressedImage =
          await _compressAndConvertToWebP(File(pickedFile.path), newFileName);
      logger.i("WebP 변환 완료: ${compressedImage?.path}");

      if (compressedImage != null) {
        // S3 Presigned URL 요청
        String? presignedUrl = await viewModel.issuePresignedUrl(newFileName);

        if (presignedUrl != null) {
          // 변환된 WebP 이미지 업로드
          return await _uploadImageToS3(compressedImage, presignedUrl);
        }
      }
    }
    return null;
  }

  // 이미지 압축 및 WebP 변환
  // 이미지 압축 및 WebP 변환 (크기에 따른 품질 조정)
  static Future<File?> _compressAndConvertToWebP(
      File imageFile, String newFileName) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final outputPath = path.join(tempDir.path, newFileName);

      // 이미지 크기 확인 (바이트 단위)
      int fileSize = imageFile.lengthSync();

      // 압축 품질 설정 (파일 크기에 따라 품질을 다르게 설정)
      int quality = 80; // 기본 품질

      // 크기에 따른 품질 분기
      if (fileSize < 100000) {
        // 100KB 이하 작은 이미지
        quality = 100;
      } else if (fileSize < 500000) {
        // 500KB 이하 작은 이미지
        quality = 95;
      } else if (fileSize < 1000000) {
        // 500KB ~ 1MB 이미지
        quality = 90;
      } else if (fileSize < 2000000) {
        // 1MB ~ 2MB 이미지
        quality = 80;
      } else if (fileSize < 5000000) {
        // 2MB ~ 5MB 이미지
        quality = 70;
      } else if (fileSize < 10000000) {
        // 5MB ~ 10MB 이미지
        quality = 60;
      } else if (fileSize < 50000000) {
        // 10MB ~ 50MB 이미지
        quality = 50;
      } else if (fileSize < 50000000) {
        // 10MB ~ 50MB 이미지
        quality = 40;
      } else {
        // 50MB 이상 크기 이미지
        quality = 30;
      }

      var compressedImage = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        outputPath,
        format: CompressFormat.webp, // WebP 변환
        quality: quality, // 설정된 압축 품질
        minWidth: 800, // 최소 너비 (설정 가능)
        minHeight: 800, // 최소 높이 (설정 가능)
      );

      if (compressedImage == null) {
        return null;
      }

      return File(compressedImage.path);
    } catch (e) {
      print("이미지 변환 중 에러 발생: $e");
      return null;
    }
  }

  // S3 업로드
  static Future<String?> _uploadImageToS3(
      File compressedFile, String presignedUrl) async {
    try {
      final dio = Dio();

      // 바이트 배열로 파일을 읽어들임
      final fileBytes = await compressedFile.readAsBytes();

      final response = await dio.put(
        presignedUrl,
        data: fileBytes, // 바이트 배열을 직접 전달
        options: Options(
          headers: {
            'Content-Type': 'image/webp', // WebP로 설정
          },
        ),
      );

      if (response.statusCode == 200) {
        String uploadedImageUrl = presignedUrl.split("?").first;
        print("업로드된 이미지 URL: $uploadedImageUrl");
        return uploadedImageUrl;
      } else {
        print("업로드 실패: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("S3 업로드 중 에러 발생: $e");
      return null;
    }
  }
}
