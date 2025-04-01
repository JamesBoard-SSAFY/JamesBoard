import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jamesboard/datasource/model/response/ArchiveListResponse.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/repository/ArchiveRepository.dart';
import 'package:jamesboard/repository/LoginRepository.dart';

class MissionViewModel extends ChangeNotifier {
  final ArchiveRepository _archiveRepository;
  final LoginRepository _loginRepository;

  List<ArchiveListResponse> _archives = [];
  List<ArchiveListResponse> get archives => _archives;

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
}
