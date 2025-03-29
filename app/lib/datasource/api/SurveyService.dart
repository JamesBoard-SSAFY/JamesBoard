import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'SurveyService.g.dart';

@RestApi(baseUrl: "https://j12d205.p.ssafy.io/")
abstract class SurveyService {
  factory SurveyService(Dio dio, {String baseUrl}) = _SurveyService;

  // 유저 선호 게임 조회
  @GET("/api/users/{userId}/prefer-games")
  Future<int> checkUserPreferBoardGame(
    @Path("userId") int userId,
  );
}
