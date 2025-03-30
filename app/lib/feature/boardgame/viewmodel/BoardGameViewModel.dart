import 'package:flutter/foundation.dart';

import 'package:jamesboard/datasource/model/response/BoardGameResponse.dart';

import '../../../repository/BoardGameRepository.dart';

class BoardGameViewModel extends ChangeNotifier {
  final BoardGameRepository _repository;
  List<BoardGameResponse> _recommendedGames = [];
  List<BoardGameResponse> get recommendedGames => _recommendedGames;

  // 카테고리별로 데이터를 관리할 Map
  Map<String, List<BoardGameResponse>> _categoryGames = {};
  Map<String, List<BoardGameResponse>> get categoryGames => _categoryGames;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  BoardGameViewModel(this._repository);

  Future<void> getRecommendedGames({int limit = 10}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommendedGames = await _repository.getRecommendedGames(limit: limit);
    } catch (e) {
      _errorMessage = 'Failed to load recommended games: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getBoardGamesForCategory(
      String category, Map<String, dynamic> queryParameters) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<BoardGameResponse> games =
          await _repository.getBoardGames(queryParameters);
      _categoryGames[category] = games;
    } catch (e) {
      _errorMessage = 'Failed to load board games: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
