import 'package:flutter/foundation.dart';
import 'package:jamesboard/datasource/model/response/BoardGameRecommendResponse.dart';

import 'package:jamesboard/datasource/model/response/BoardGameResponse.dart';
import 'package:jamesboard/datasource/model/response/BoardGameTopResponse.dart';
import 'package:jamesboard/main.dart';

import '../../../datasource/model/response/BoardGameDetailResponse.dart';
import '../../../repository/BoardGameRepository.dart';

class BoardGameViewModel extends ChangeNotifier {
  final BoardGameRepository _repository;

  List<BoardGameRecommendResponse> _recommendedGames = [];
  List<BoardGameRecommendResponse> get recommendedGames => _recommendedGames;

  List<BoardGameResponse> _games = [];
  List<BoardGameResponse> get games => _games;

  List<BoardGameTopResponse> _topGames = [];
  List<BoardGameTopResponse> get topGames => _topGames;

  BoardGameDetailResponse? _boardGameDetail;
  BoardGameDetailResponse? get boardGameDetail => _boardGameDetail;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int? _selectedGameId;
  int? get selectedGameId => _selectedGameId;

  BoardGameViewModel(this._repository);

  Future<void> getRecommendedGames({int limit = 10}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (_recommendedGames.isNotEmpty) {
      _isLoading = false;
      notifyListeners();
    }

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
      Map<String, dynamic> queryParameters) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _games = await _repository.getBoardGames(queryParameters);
      logger.d('boardGameviewmoel : games : $_games');
    } catch (e) {
      _errorMessage = 'Failed to load board games: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTopGames(Map<String, dynamic> queryParameters) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (_topGames.isNotEmpty) {
      _isLoading = false;
      notifyListeners();
    }

    try {
      _topGames = await _repository.getTopGames(queryParameters);

      logger.d("viewModel topGames : ${topGames}");
    } catch (e) {
      _errorMessage = 'Failed to load board games: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedGameId({required int gameId}) {
    _selectedGameId = gameId;
    notifyListeners();
  }

  Future<void> getBoardGameDetail(int gameId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _boardGameDetail = await _repository.getBoardGameDetail(gameId);

      logger.d("viewmodel: ${boardGameDetail}");
    } catch (e) {
      _errorMessage = 'Failed to load board game detail: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearchResults() {
    _games = [];
    notifyListeners();
  }
}
