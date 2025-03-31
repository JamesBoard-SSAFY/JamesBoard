import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jamesboard/repository/MyPageRepository.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPageUserInfoResponse.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPageMissionRecordResponse.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPagePlayedGames.dart';
import 'package:jamesboard/datasource/model/response/MyPage/MyPageGameStatsResponse.dart';
import '../../../datasource/model/request/MyPage/MyPageUserInfoRequest.dart';
import '../../../main.dart';

class MyPageViewModel extends ChangeNotifier {
  final MyPageRepository _myPageRepository;
  final FlutterSecureStorage _storage;

  int? userId;
  MyPageUserInfoResponse? userInfo;
  MyPageMissionRecordResponse? missionRecord;
  List<MyPagePlayedGames>? playedGames;
  MyPageGameStatsResponse? gameStats;
  bool isLoading = false;

  // 생성자: userId를 직접 불러오지 않고, main.dart에서 설정
  MyPageViewModel(this._myPageRepository, this._storage);

  /// 저장된 userId 불러오기 (main.dart에서 사용)
  Future<void> loadUserId() async {
    try {
      String? storedUserId = await _storage.read(key: "userId");
      if (storedUserId != null) {
        userId = int.tryParse(storedUserId);
        notifyListeners();
        await getUserInfo(); // userId 설정 후 사용자 정보 불러오기
      }
    } catch (e) {
      logger.e("flutter - loadUserId: $e");
    }
  }

  /// 사용자 정보 조회
  Future<void> getUserInfo() async {
    if (userId == null) return;
    try {
      isLoading = true;
      notifyListeners();
      userInfo = await _myPageRepository.getUserInfo(userId!);
      logger.d("flutter - getUserInfo: $userInfo");
    } catch (e) {
      logger.e("flutter - getUserInfo: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 사용자 정보 수정
  Future<void> editUserInfo(MyPageUserInfoRequest request) async {
    if (userId == null) return;
    try {
      isLoading = true;
      notifyListeners();
      await _myPageRepository.editUserInfo(userId!, request);
      await getUserInfo(); // 업데이트 후 정보 다시 로드
    } catch (e) {
      logger.e("flutter - editUserInfo: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 사용자의 특정 게임 미션 기록 조회
  Future<void> getMissionRecord(int gameId) async {
    if (userId == null) return;
    try {
      isLoading = true;
      notifyListeners();
      missionRecord = await _myPageRepository.getMissionRecord(userId!, gameId);
    } catch (e) {
      logger.e("flutter - getMissionRecord: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 사용자 플레이한 게임 목록 조회
  Future<void> getAllPlayedGames() async {
    if (userId == null) return;
    try {
      isLoading = true;
      notifyListeners();
      playedGames = await _myPageRepository.getAllPlayedGames(userId!);
    } catch (e) {
      logger.e("flutter - getAllPlayedGames: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 사용자 게임 통계 및 순위 조회
  Future<void> getTopPlayedGame() async {
    if (userId == null) return;
    try {
      isLoading = true;
      notifyListeners();
      gameStats = await _myPageRepository.getTopPlayedGame(userId!);
    } catch (e) {
      logger.e("flutter - getTopPlayedGame: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 유저 선호 게임 여부 조회
  Future<void> getPreferGame() async {
    if (userId == null) return;
    try {
      isLoading = true;
      notifyListeners();
      await _myPageRepository.getPreferGame(userId!);
    } catch (e) {
      logger.e("flutter - getPreferGame: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
