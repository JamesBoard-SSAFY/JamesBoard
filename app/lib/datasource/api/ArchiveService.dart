import 'package:dio/dio.dart';
import 'package:jamesboard/datasource/model/response/ArchiveDetailResponse.dart';
import 'package:jamesboard/datasource/model/response/ArchiveListResponse.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../model/request/ArchiveEditRequest.dart';

part 'ArchiveService.g.dart';

@RestApi(baseUrl: "https://j12d205.p.ssafy.io")
abstract class ArchiveService {
  factory ArchiveService(Dio dio, {String baseUrl}) = _ArchiveService;

  // 아카이브 전체 조회
  @GET("/api/archives")
  Future<List<ArchiveListResponse>> getAllArchives();

  // 아카이브 상세 조회
  @GET("/api/archives/{archiveId}")
  Future<ArchiveDetailResponse> getArchiveById(
    @Path("archiveId") int archiveId,
  );

  // 아카이브 등록
  @POST("/api/archives")
  Future<int> insertArchive(
    @Body() ArchiveEditRequest request,
  );

  // 아카이브 수정
  @PATCH("/api/archives/{archiveId}")
  Future<int> updateArchive(
    @Path("archiveId") int archiveId,
    @Body() ArchiveEditRequest request,
  );

  // 아카이브 삭제
  @DELETE("/api/archives/{archiveId}")
  Future<int> deleteArchive(
    @Path("archiveId") int archiveId,
  );
}
