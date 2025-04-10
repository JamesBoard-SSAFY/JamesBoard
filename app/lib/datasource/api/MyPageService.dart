import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../model/request/MyPage/MyPageUserInfoRequest.dart';
import '../model/response/MyPage/MyPageMissionRecordResponse.dart';
import '../model/response/MyPage/MyPagePlayedGames.dart';
import '../model/response/MyPage/MyPageGameStatsResponse.dart';
import '../model/response/MyPage/MyPageUserIdResponse.dart';
import '../model/response/MyPage/MyPageUserInfoResponse.dart';

part 'MyPageService.g.dart';

@RestApi(baseUrl: "https://j12d205.p.ssafy.io/")
abstract class MyPageService {
  factory MyPageService(Dio dio, {String baseUrl}) = _MyPageService;

  // 사용자 정보 조회
  @GET("/api/users/{userId}")
  Future<MyPageUserInfoResponse> getUserInfo(
    @Path("userId") int userId,
  );

  // 사용자 정보 수정
  @PATCH("/api/users/{userId}")
  Future<MyPageUserIdResponse> editUserInfo(
    @Path("userId") int userId,
    @Body() MyPageUserInfoRequest request,
  );

  // 사용자의 특정 게임 아카이브 조회
  @GET("/api/users/{userId}/archives")
  Future<MyPageMissionRecordResponse> getMissionRecord(
    @Path("userId") int userId,
    @Query("gameId") int gameId,
  );

  // 사용자 플레이 게임 목록 조회
  @GET("/api/users/{userId}/archives/games")
  Future<List<MyPagePlayedGames>> getAllPlayedGames(
    @Path("userId") int userId,
  );

  // 유저 선호게임 여부 조회
  @GET("/api/users/{userId}/prefer-games")
  Future<int> getPreferGame(
    @Path("userId") int userId,
  );

  // 사용자 게임 통계 및 순위 조회
  @GET("/api/users/{userId}/statics")
  Future<MyPageGameStatsResponse> getTopPlayedGame(
    @Path("userId") int userId,
  );
}
