import 'package:jamesboard/datasource/api/MyPageService.dart';
import '../datasource/model/request/MyPage/MyPageUserInfoRequest.dart';
import '../datasource/model/response/MyPage/MyPageGameStatsResponse.dart';
import '../datasource/model/response/MyPage/MyPageMissionRecordResponse.dart';
import '../datasource/model/response/MyPage/MyPagePlayedGames.dart';
import '../datasource/model/response/MyPage/MyPageUserIdResponse.dart';
import '../datasource/model/response/MyPage/MyPageUserInfoResponse.dart';
import '../util/DioProviderUtil.dart';

class MyPageRepository {
  final MyPageService _myPageService;

  MyPageRepository._(this._myPageService);

  factory MyPageRepository.create() {
    final service = MyPageService(DioProviderUtil.dio);
    return MyPageRepository._(service);
  }

  // 사용자 정보 조회
  Future<MyPageUserInfoResponse> getUserInfo(int userId) => _myPageService.getUserInfo(userId);

  // 사용자 정보 수정
  Future<MyPageUserIdResponse> editUserInfo(int userId, MyPageUserInfoRequest request) => _myPageService.editUserInfo(userId, request);

  // 사용자의 특정 게임 아카이브 조회
  Future<MyPageMissionRecordResponse> getMissionRecord(int userId, int gameId) => _myPageService.getMissionRecord(userId, gameId);

  // 사용자 플레이 게임 목록 조회
  Future<List<MyPagePlayedGames>> getAllPlayedGames(int userId) => _myPageService.getAllPlayedGames(userId);

  // 유저 선호게임 여부 조회
  Future<int> getPreferGame(int userId) => _myPageService.getPreferGame(userId);

  // 사용자 게임 통계 및 순위 조회
  Future<MyPageGameStatsResponse> getTopPlayedGame(int userId) => _myPageService.getTopPlayedGame(userId);
}
