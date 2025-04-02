import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jamesboard/datasource/model/response/ArchiveListResponse.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/repository/ArchiveRepository.dart';
import 'package:jamesboard/repository/LoginRepository.dart';

import '../../../datasource/model/request/ArchiveEditRequest.dart';
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

  List<String> _imageUrls = [];
  List<String> get imageUrls => _imageUrls;

  String? _archiveContent;
  String? get archiveContent => _archiveContent;

  int? _archivePlayCount;
  int? get archivePlayCount => _archivePlayCount;

  int? _archivePlayTime;
  int? get archivePlayTime => _archivePlayTime;

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

  void addImageUrl(String url) {
    _imageUrls.add(url);
    notifyListeners();
  }

  void removeImageUrl(int index) {
    if (index >= 0 && index < _imageUrls.length) {
      _imageUrls.removeAt(index);
      notifyListeners();
    }
  }

  void setArchivePlayContent(String content) {
    _archiveContent = content;
    notifyListeners();
  }

  void setArchivePlayCount(int count) {
    _archivePlayCount = count;
    notifyListeners();
  }

  void setArchivePlayTime() {
    if (_selectedGameAveragePlayTime == null || _archivePlayCount == null)
      return;
    _archivePlayTime = _selectedGameAveragePlayTime! * _archivePlayCount!;
    notifyListeners();
  }

  // 유효성 검사
  String? validationArchiveSubmission() {
    if (_selectedGameId == null) return '보드게임을 선택해주세요.';
    if (_archivePlayTime == null || _archivePlayCount! <= 0)
      return '임무 수(플레이한 횟수)를 입력해주세요.';
    if (_imageUrls.isEmpty) return '사진을 한 장 이상 업로드 해주세요.';
    if (_archiveContent == null || _archiveContent!.isEmpty)
      return '임무 결과(문구)를 입력해주세요.';
    return null;
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

  // 아카이브 등록
  Future<int> insertArchive(ArchiveEditRequest request) async {
    try {
      final response = await _archiveRepository.insertArchive(request);
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _loginRepository.logout();
        logger.e('401 에러. 로그아웃 처리.');
      }
    } catch (e) {
      logger.e('서버 오류 $e');
    }

    return -1;
  }

  // 아카이브 수정
  Future<int> updateArchive(int archiveId, ArchiveEditRequest request) async {
    try {
      final response =
          await _archiveRepository.updateArchive(archiveId, request);
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _loginRepository.logout();
        logger.e('401 에러. 로그아웃 처리');
      }
    } catch (e) {
      logger.e('서버 오류 $e');
    }

    return -1;
  }

  // 아카이브 삭제
  Future<int> deleteArchive(int archiveId) async {
    try {
      final response = await _archiveRepository.deleteArchive(archiveId);
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _loginRepository.logout();
        logger.e('401 에러. 로그아웃 처리');
      }
    } catch (e) {
      logger.e('서버 오류 $e');
    }

    return -1;
  }
}
