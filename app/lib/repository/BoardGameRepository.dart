import 'package:jamesboard/datasource/model/response/BoardGameDetailResponse.dart';
import 'package:jamesboard/datasource/model/response/BoardGameRecommendResponse.dart';
import 'package:jamesboard/datasource/model/response/BoardGameTopResponse.dart';

import '../datasource/api/BoardGameService.dart';
import '../datasource/model/response/BoardGameResponse.dart';
import '../util/DioProviderUtil.dart';

class BoardGameRepository {
  final BoardGameService _service;

  BoardGameRepository._(this._service);

  factory BoardGameRepository.create() {
    final dio = DioProviderUtil.dio;

    final service = BoardGameService(dio);
    return BoardGameRepository._(service);
  }

  Future<List<BoardGameRecommendResponse>> getRecommendedGames(
          {int limit = 10}) =>
      _service.getRecommendedGames(limit: limit);

  Future<List<BoardGameResponse>> getBoardGames(
          Map<String, dynamic> queryParameters) =>
      _service.getBoardGamesForCategory(
        difficulty: queryParameters['difficulty'] ?? null,
        minPlayers: queryParameters['minPlayers'] ?? null,
        category: queryParameters['category'] ?? null,
        boardGameName: queryParameters['boardGameName'] ?? null,
      );

  Future<List<BoardGameTopResponse>> getTopGames(
          Map<String, dynamic> queryParameters) =>
      _service.getTopGames(
        sortBy: queryParameters['sortBy'] ?? null,
        limit: queryParameters['limit'] ?? null,
      );

  Future<BoardGameDetailResponse> getBoardGameDetail(int gameId) =>
      _service.getBoardGameDetail(gameId);
}
