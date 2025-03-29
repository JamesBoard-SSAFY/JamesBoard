import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'UserService.g.dart';

@RestApi(baseUrl: "https://j12d205.p.ssafy.io/")
abstract class UserService {
  factory UserService(Dio dio, {String baseUrl}) = _UserService;

  // 유저 선호 게임 조회
  @GET("/api/users/{userId}/prefer-games")
  Future<int> checkUserPreferBoardGame(
    @Path("userId") int userId,
  );
}
