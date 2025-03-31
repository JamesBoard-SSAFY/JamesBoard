import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jamesboard/repository/MyPageRepository.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPageUserInfoResponse.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPageMissionRecordResponse.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPagePlayedGames.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPageGameStatsResponse.dart';
import 'package:logger/logger.dart';

import '../../../datasource/model/request/MyPage/MyPageUserInfoRequest.dart';
import '../../../main.dart';

class MyPageViewModel extends ChangeNotifier {
  final MyPageRepository _myPageRepository;
  final FlutterSecureStorage storage;

  int? userId;
  MyPageUserInfoResponse? userInfo;
  MyPageMissionRecordResponse? missionRecord;
  List<MyPagePlayedGames>? playedGames;
  MyPageGameStatsResponse? gameStats;
  bool isLoading = false;

  // 생성자
  MyPageViewModel(this._myPageRepository, this.storage) {
    _loadUserId();
  }

  // 저장된 userId 불러오기
  Future<void> _loadUserId() async {
    String? storedUserId = await storage.read(key: "userId");
    if (storedUserId != null) {
      userId = int.tryParse(storedUserId);
      notifyListeners();
      getUserInfo(); // userId 설정 후 사용자 정보 불러오기
    }
  }

  // 사용자 정보 조회
  Future<void> getUserInfo() async {
    if (userId == null) return; // userId가 없으면 요청하지 않음
    try {
      userInfo = await _myPageRepository.getUserInfo(userId!);
      logger.d("flutter - getUserInfo: $userInfo");
      notifyListeners();
    } catch (e) {
      logger.e("flutter - getUserInfo: $e");
    }
  }

  // 사용자 정보 수정
  Future<void> editUserInfo(int userId, MyPageUserInfoRequest request) async {
    try {
      isLoading = true;
      notifyListeners();
      await _myPageRepository.editUserInfo(userId, request);
    } catch (e) {
      // 에러 처리
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 사용자의 특정 게임 아카이브 조회
  Future<void> getMissionRecord(int userId, int gameId) async {
    try {
      isLoading = true;
      notifyListeners();
      missionRecord = await _myPageRepository.getMissionRecord(userId, gameId);
    } catch (e) {
      // 에러 처리
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 사용자 플레이 게임 목록 조회
  Future<void> getAllPlayedGames(int userId) async {
    try {
      isLoading = true;
      notifyListeners();
      playedGames = await _myPageRepository.getAllPlayedGames(userId);
    } catch (e) {
      // 에러 처리
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 사용자 게임 통계 및 순위 조회
  Future<void> getTopPlayedGame(int userId) async {
    try {
      isLoading = true;
      notifyListeners();
      gameStats = await _myPageRepository.getTopPlayedGame(userId);
    } catch (e) {
      // 에러 처리
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 유저 선호게임 여부 조회
  Future<void> getPreferGame(int userId) async {
    try {
      isLoading = true;
      notifyListeners();
      await _myPageRepository.getPreferGame(userId);
    } catch (e) {
      // 에러 처리
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
