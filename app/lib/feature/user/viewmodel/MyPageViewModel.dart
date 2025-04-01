import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jamesboard/repository/MyPageRepository.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPageUserInfoResponse.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPageMissionRecordResponse.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPagePlayedGames.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPageGameStatsResponse.dart';
import 'package:jamesboard/repository/S3Repository.dart';
import '../../../datasource/model/request/MyPage/MyPageUserInfoRequest.dart';
import '../../../main.dart';
import '../../../repository/LoginRepository.dart';
import 'package:dio/dio.dart';

class MyPageViewModel extends ChangeNotifier {
  final MyPageRepository _myPageRepository;
  final LoginRepository _loginRepository;
  final S3Repository _s3repository;
  final FlutterSecureStorage _storage;

  int? userId;
  MyPageUserInfoResponse? userInfo;
  MyPageMissionRecordResponse? missionRecord;
  List<MyPagePlayedGames>? playedGames;
  MyPageGameStatsResponse? gameStats;
  String? presignedUrl;
  bool isLoading = false;

  MyPageViewModel(
    this._myPageRepository,
    this._loginRepository,
    this._s3repository,
    this._storage,
  );

  Future<String?> issuePresignedUrl(String fileName) async {
    try {
      isLoading = true;
      notifyListeners();

      presignedUrl = await _s3repository.issuePresignedUrl(fileName);
      logger.i("Presigned URL 발급 성공: $presignedUrl");
      return presignedUrl;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리');
        await _loginRepository.logout();
      } else {
        logger.e('기타 DIO 에러: $e');
      }
    } catch (e) {
      logger.e("flutter - issuePresignedUrl: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> loadUserId() async {
    try {
      String? storedUserId = await _storage.read(key: "userId");
      if (storedUserId != null) {
        userId = int.tryParse(storedUserId);
        notifyListeners();
        await getUserInfo();
      }
    } catch (e) {
      logger.e("flutter - loadUserId: $e");
    }
  }

  Future<void> getUserInfo() async {
    if (userId == null) return;
    try {
      isLoading = true;
      notifyListeners();
      userInfo = await _myPageRepository.getUserInfo(userId!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리');
        await _loginRepository.logout();
      } else {
        logger.e('기타 DIO 에러: $e');
      }
    } catch (e) {
      logger.e("flutter - getUserInfo: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editUserInfo(MyPageUserInfoRequest request) async {
    if (userId == null) return;
    try {
      isLoading = true;
      notifyListeners();
      await _myPageRepository.editUserInfo(userId!, request);
      await getUserInfo();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리');
        await _loginRepository.logout();
      } else {
        logger.e('기타 DIO 에러: $e');
      }
    } catch (e) {
      logger.e("flutter - editUserInfo: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMissionRecord(int gameId) async {
    if (userId == null) return;
    try {
      isLoading = true;
      logger.d('Mission Record - $userId - $gameId');
      notifyListeners();
      missionRecord = await _myPageRepository.getMissionRecord(userId!, gameId);
      // 성공적으로 데이터를 받은 경우
      logger.d('Mission Record: $missionRecord');
    } on DioException catch (e) {
      // DioException 처리
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리');
        await _loginRepository.logout();
      } else {
        logger.e('기타 DIO 에러: $e');
      }
      // DioException 발생 시에도 로그
      logger.d('DioException: $e');
    } catch (e) {
      // 다른 예외 처리
      logger.e("flutter - getMissionRecord: $e");
      // 예외 발생 시에도 로그
      logger.d('Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllPlayedGames() async {
    if (userId == null) return;
    try {
      isLoading = true;
      notifyListeners();
      playedGames = await _myPageRepository.getAllPlayedGames(userId!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리');
        await _loginRepository.logout();
      } else {
        logger.e('기타 DIO 에러: $e');
      }
    } catch (e) {
      logger.e("flutter - getAllPlayedGames: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTopPlayedGame() async {
    if (userId == null) return;
    try {
      isLoading = true;
      notifyListeners();
      gameStats = await _myPageRepository.getTopPlayedGame(userId!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리');
        await _loginRepository.logout();
      } else {
        logger.e('기타 DIO 에러: $e');
      }
    } catch (e) {
      logger.e("flutter - getTopPlayedGame: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPreferGame() async {
    if (userId == null) return;
    try {
      isLoading = true;
      notifyListeners();
      await _myPageRepository.getPreferGame(userId!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리');
        await _loginRepository.logout();
      } else {
        logger.e('기타 DIO 에러: $e');
      }
    } catch (e) {
      logger.e("flutter - getPreferGame: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
