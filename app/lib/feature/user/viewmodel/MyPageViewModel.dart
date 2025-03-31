import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jamesboard/repository/MyPageRepository.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPageUserInfoResponse.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPageMissionRecordResponse.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPagePlayedGames.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPageGameStatsResponse.dart';
import '../../../datasource/model/request/MyPage/MyPageUserInfoRequest.dart';
import '../../../main.dart';
import '../../../repository/LoginRepository.dart';
import 'package:dio/dio.dart';

class MyPageViewModel extends ChangeNotifier {
  final MyPageRepository _myPageRepository;
  final LoginRepository _loginRepository;
  final FlutterSecureStorage _storage;

  int? userId;
  MyPageUserInfoResponse? userInfo;
  MyPageMissionRecordResponse? missionRecord;
  List<MyPagePlayedGames>? playedGames;
  MyPageGameStatsResponse? gameStats;
  bool isLoading = false;

  MyPageViewModel(
      this._myPageRepository,
      this._loginRepository,
      this._storage,
      );

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
      logger.d("flutter - getUserInfo: $userInfo");
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
      notifyListeners();
      missionRecord = await _myPageRepository.getMissionRecord(userId!, gameId);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리');
        await _loginRepository.logout();
      } else {
        logger.e('기타 DIO 에러: $e');
      }
    } catch (e) {
      logger.e("flutter - getMissionRecord: $e");
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