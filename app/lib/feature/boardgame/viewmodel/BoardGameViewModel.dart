import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:jamesboard/datasource/model/local/AppDatabase.dart';
import 'package:jamesboard/datasource/model/response/BoardGameRecommendResponse.dart';

import 'package:jamesboard/datasource/model/response/BoardGameResponse.dart';
import 'package:jamesboard/datasource/model/response/BoardGameTopResponse.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/repository/RecentSearchRepository.dart';

import '../../../datasource/model/response/BoardGameDetailResponse.dart';
import '../../../repository/BoardGameRepository.dart';

class BoardGameViewModel extends ChangeNotifier {
  final BoardGameRepository _repository;
  final RecentSearchRepository? _recentSearchRepository;

  List<RecentSearche> _recentSearches = [];
  List<RecentSearche> get recentSearches => _recentSearches;

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

  BoardGameViewModel(this._repository, [this._recentSearchRepository]);

  Future<void> getRecommendedGames({int limit = 10}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommendedGames = await _repository.getRecommendedGames(limit: limit);
      _recommendedGames = _recommendedGames.sublist(0, 9);
    } catch (e) {
      _errorMessage = 'Failed to load recommended games: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getBoardGames(Map<String, dynamic> queryParameters) async {
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

      logger.d("logger viewmodel: ${boardGameDetail.toString()}");
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

  // 최근 검색어 저장
  Future<void> saveRecentSearch(String keyword) async {
    if (_recentSearchRepository == null) return;
    await _recentSearchRepository.saveRecentSearch(keyword);
    await getRecentSearches();
  }

  // 최근 검색어 최대 10개 최신순으로 가져오기
  Future<void> getRecentSearches() async {
    if (_recentSearchRepository == null) return;
    _recentSearches = await _recentSearchRepository.getRecentSearches();
    notifyListeners();
  }

  // 특정 검색어 삭제
  Future<void> deleteRecentSearch(int id) async {
    if (_recentSearchRepository == null) return;
    await _recentSearchRepository.deleteRecentSearch(id);
    await getRecentSearches();
  }
}
