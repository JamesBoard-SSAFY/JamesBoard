import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jamesboard/datasource/model/local/AppDatabase.dart';
import 'package:jamesboard/datasource/model/response/BoardGameRecommendResponse.dart';

import 'package:jamesboard/datasource/model/response/BoardGameResponse.dart';
import 'package:jamesboard/datasource/model/response/BoardGameTopResponse.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/repository/LoginRepository.dart';
import 'package:jamesboard/repository/RecentSearchRepository.dart';

import '../../../datasource/model/response/BoardGameDetailResponse.dart';
import '../../../repository/BoardGameRepository.dart';
import 'dart:async';

class BoardGameViewModel extends ChangeNotifier {
  final BoardGameRepository _repository;
  final RecentSearchRepository? _recentSearchRepository;
  final LoginRepository _loginRepository;

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

  DateTime? _lastFetchTime;
  final Duration _cacheDuration = Duration(seconds: 30);

  int? _selectedGameId;

  int? get selectedGameId => _selectedGameId;

  BoardGameViewModel(this._repository, this._loginRepository,
      [this._recentSearchRepository]);

  Future<void> getRecommendedGames({int limit = 10}) async {
    final now = DateTime.now();
    final startTime = DateTime.now(); // ✅ 시작 시각

    if (_lastFetchTime != null &&
        now.difference(_lastFetchTime!) < _cacheDuration &&
        _recommendedGames.isNotEmpty) {
      final duration = DateTime.now().difference(startTime);
      logger.i('재사용 로딩 시간: ${duration.inMilliseconds} ms'); // ✅ 로딩 시간 로그
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final games = await _repository.getRecommendedGames(limit: limit);
      _recommendedGames = games.sublist(0, 9);
      _lastFetchTime = DateTime.now(); // 마지막 호출 시간 갱신

      final duration = DateTime.now().difference(startTime);
      logger.i('서버 요청 로딩 시간: ${duration.inMilliseconds} ms'); // ✅ 로딩 시간 로그
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리.');
        await _loginRepository.logout();
      }
    } catch (e) {
      _errorMessage = 'Failed to load recommended games: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> getBoardGames(Map<String, dynamic> queryParameters) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      if (_games.isEmpty) {
        _games = await _repository.getBoardGames(queryParameters);
      }

      logger.d('boardGameviewmoel : games : $_games');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리.');
        await _loginRepository.logout();
      }
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
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리.');
        await _loginRepository.logout();
      }
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
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리.');
        await _loginRepository.logout();
      }
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
