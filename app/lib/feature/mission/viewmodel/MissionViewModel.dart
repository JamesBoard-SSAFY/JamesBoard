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

  List<ArchiveListResponse> _archives = [];
  List<ArchiveListResponse> get archives => _archives;

  bool isLoading = false;
  bool hasError = false;

  ArchiveDetailResponse? archiveDetailResponse;

  MissionViewModel(
    this._archiveRepository,
    this._loginRepository,
  );

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
