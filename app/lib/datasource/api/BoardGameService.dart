import 'package:dio/dio.dart';
import 'package:jamesboard/datasource/model/response/BoardGameResponse.dart';
import 'package:jamesboard/main.dart';
import 'package:retrofit/retrofit.dart';

part 'BoardGameService.g.dart';

@RestApi(baseUrl: "https://j12d205.p.ssafy.io/")
abstract class BoardGameService {
  factory BoardGameService(Dio dio, {String baseUrl}) = _BoardGameService;

  @GET("api/games/recommendations")
  Future<List<BoardGameResponse>> getRecommendedGames(
      {@Query("limit") int limit = 10});

  @GET("api/games")
  Future<List<BoardGameResponse>> getBoardGames({
    @Query("difficulty") int? difficulty,
    @Query("minPlayers") int? minPlayers,
    @Query("boardgameName") String? boardgameName,
    @Query("category") String? category,
  });
}
