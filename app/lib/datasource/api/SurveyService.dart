import 'package:dio/dio.dart';
import 'package:jamesboard/datasource/model/response/SurveyBoardGameResponse.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../model/request/SurveyBoardGameRequest.dart';

part 'SurveyService.g.dart';

@RestApi(baseUrl: "https://j12d205.p.ssafy.io")
abstract class SurveyService {
  factory SurveyService(Dio dio, {String baseUrl}) = _SurveyService;

  // 유저 선호 게임 조회
  @GET("/api/users/{userId}/prefer-games")
  Future<int> checkUserPreferBoardGame(
    @Path("userId") int userId,
  );

  // 장르별 TOP 30 보드게임 조회
  @GET("/api/onboard/games")
  Future<List<SurveyBoardGameResponse>> getTop30BoardGameByGenre(
    @Query("category") String category,
  );

  // 유저 선호게임 수정(사실상 등록)
  @PATCH("/api/onboard/users/{userId}/prefer-games")
  Future<int> insertUserPreferBoardGameSurvey(
    @Body() SurveyBoardGameRequest request,
  );
}
