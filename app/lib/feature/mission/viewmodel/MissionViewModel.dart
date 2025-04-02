import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jamesboard/datasource/model/response/ArchiveListResponse.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/repository/ArchiveRepository.dart';
import 'package:jamesboard/repository/LoginRepository.dart';

import '../../../datasource/model/response/ArchiveDetailResponse.dart';

class MissionViewModel extends ChangeNotifier {
  final ArchiveRepository _archiveRepository;
  final LoginRepository _loginRepository;

  MissionViewModel(
    this._archiveRepository,
    this._loginRepository,
  );

  List<ArchiveListResponse> _archives = [];
  List<ArchiveListResponse> get archives => _archives;

  bool isLoading = false;
  bool hasError = false;

  ArchiveDetailResponse? archiveDetailResponse;

  int? loginUserId;

  String? _selectedGameTitle;
  String? get selectedGameTitle => _selectedGameTitle;

  int? _selectedGameId;
  int? get selectedGameId => _selectedGameId;

  int? _selectedGameAveragePlayTime;
  int? get selectedGameAveragePlayTime => _selectedGameAveragePlayTime;

  // 검색해서 선택한 보드게임 정보 저장.
  void setSelectedBoardGame(
      {required int gameId,
      required String gameTitle,
      required int gamePlayTime}) {
    _selectedGameId = gameId;
    _selectedGameTitle = gameTitle;
    _selectedGameAveragePlayTime = gamePlayTime;
    notifyListeners();
  }

  void clearSelectedBoardGame() {
    _selectedGameId = null;
    _selectedGameTitle = null;
    notifyListeners();
  }

  // 로그인한 userId 조회
  Future<void> loadLoginUserId() async {
    final userIdStr = await storage.read(key: 'userId');
    loginUserId = int.tryParse(userIdStr ?? '');
    notifyListeners();
  }

  // 아카이브 전체 조회
  Future<void> getAllArchives() async {
    try {
      _archives = await _archiveRepository.getAllArchives();
      notifyListeners();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리');
        await _loginRepository.logout();
      }
    } catch (e) {
      logger.e('아카이브 전체 조회 실패 : $e');
    }
  }

  // 아카이브 상세 조회
  Future<void> getArchiveById(int archiveId) async {
    isLoading = true;
    hasError = false;
    archiveDetailResponse = null;
    notifyListeners();

    try {
      archiveDetailResponse =
          await _archiveRepository.getArchiveById(archiveId);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logger.e('401 에러 발생. 로그아웃 처리.');
        await _loginRepository.logout();
      }
      hasError = true;
    } catch (e) {
      logger.e('아카이브 상세 조회 실패 : $e');
      hasError = true;
    }

    isLoading = false;
    notifyListeners();
  }
}
