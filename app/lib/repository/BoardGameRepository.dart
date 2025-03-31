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

  // 추천 보드게임 리스트를 반환하는 메서드
  Future<List<BoardGameResponse>> getRecommendedGames({int limit = 10}) =>
      _service.getRecommendedGames(limit: limit);

  Future<List<BoardGameResponse>> getBoardGames(
      Map<String, dynamic> queryParameters) {
    return _service.getBoardGames(
      difficulty: queryParameters['difficulty'] ?? null,
      minPlayers: queryParameters['minPlayers'] ?? null,
      category: queryParameters['category'] ?? null,
      boardgameName: queryParameters['boardgameName'] ?? null,
    );
  }

  Future<List<BoardGameTopResponse>> getTopGames(
      Map<String, dynamic> queryParameters) {
    return _service.getTopGames(
      sortBy: queryParameters['sortBy'] ?? null,
      limit: queryParameters['limit'] ?? null,
    );
  }
}
