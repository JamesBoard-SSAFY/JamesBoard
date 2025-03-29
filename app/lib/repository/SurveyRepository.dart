import 'package:jamesboard/datasource/api/SurveyService.dart';
import 'package:jamesboard/util/DioProviderUtil.dart';

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
}
