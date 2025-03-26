import 'package:dio/dio.dart';
import 'package:jamesboard/datasource/api/ArchiveService.dart';
import 'package:jamesboard/main.dart';

import '../datasource/model/request/ArchiveEditRequest.dart';
import '../datasource/model/response/ArchiveDetailResponse.dart';
import '../datasource/model/response/ArchiveListResponse.dart';

class ArchiveRepository {
  final ArchiveService _service;

  ArchiveRepository._(this._service);

  factory ArchiveRepository.create() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://j12d205.p.ssafy.io/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken' // 여기에 accessToken을 넣으면 될 듯
      },
    ));

    final service = ArchiveService(dio);
    return ArchiveRepository._(service);
  }

  // 아카이브 전체 조회
  Future<List<ArchiveListResponse>> getAllArchives() =>
      _service.getAllArchives();

  // 아카이브 상세 조회
  Future<ArchiveDetailResponse> getArchiveById(int archiveId) =>
      _service.getArchiveById(archiveId);

  // 아카이브 등록
  Future<int> insertArchive(ArchiveEditRequest request) =>
      _service.insertArchive(request);

  // 아카이브 수정
  Future<int> updateArchive(int archiveId, ArchiveEditRequest request) =>
      _service.updateArchive(archiveId, request);

  // 아카이브 삭제
  Future<int> deleteArchive(int archiveId) => _service.deleteArchive(archiveId);
}
