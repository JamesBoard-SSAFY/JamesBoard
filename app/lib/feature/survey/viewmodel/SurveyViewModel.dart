import 'package:flutter/cupertino.dart';
import 'package:jamesboard/datasource/model/response/SurveyBoardGameResponse.dart';
import 'package:jamesboard/repository/SurveyRepository.dart';

import '../../../datasource/model/request/SurveyBoardGameRequest.dart';
import '../../../main.dart';

class SurveyViewModel extends ChangeNotifier {
  final SurveyRepository _surveyRepository;

  List<SurveyBoardGameResponse> _boardGames = [];
  List<SurveyBoardGameResponse> get boardGames => _boardGames;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SurveyViewModel(
    this._surveyRepository,
  );

  Future<void> getTop30BoardGameByGenre(String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      _boardGames = await _surveyRepository.getTop30BoardGameByGenre(category);
    } catch (e) {
      logger.d('카테고리에 맞는 보드게임 갖고오기 실패 : Survey : $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> insertUserPreferBoardGameSurvey(
      int userId, SurveyBoardGameRequest request) async {
    try {
      final result = await _surveyRepository.insertUserPreferBoardGameSurvey(
          userId, request);
      logger.d('선호 보드게임 등록 성공 : $result');
      return result;
    } catch (e) {
      logger.e('선호 보드게임 등록 실패 : $e');
      return 0;
    }
  }
}
