import 'package:jamesboard/datasource/api/SurveyService.dart';
import 'package:jamesboard/util/DioProviderUtil.dart';

import '../datasource/model/request/SurveyBoardGameRequest.dart';
import '../datasource/model/response/SurveyBoardGameResponse.dart';

class SurveyRepository {
  final SurveyService _service;

  SurveyRepository._(this._service);

  factory SurveyRepository.create() {
    final service = SurveyService(DioProviderUtil.dio);
    return SurveyRepository._(service);
  }

  // 유저 선호 게임 조회
  Future<int> checkUserPreferBoardGame(int userId) =>
      _service.checkUserPreferBoardGame(userId);

  // 장르별 TOP 30 보드게임 조회
  Future<List<SurveyBoardGameResponse>> getTop30BoardGameByGenre(
          String category) =>
      _service.getTop30BoardGameByGenre(category);

  // 유저 선호게임 수정(사실상 등록)
  Future<int> insertUserPreferBoardGameSurvey(SurveyBoardGameRequest request) =>
      _service.insertUserPreferBoardGameSurvey(request);
}
