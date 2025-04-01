import 'package:jamesboard/datasource/api/S3Service.dart';
import '../util/DioProviderUtil.dart';

class S3Repository {
  final S3Service _s3service;

  S3Repository._(this._s3service);

  factory S3Repository.create() {
    final service = S3Service(DioProviderUtil.dio);
    return S3Repository._(service);
  }

  // presigned url 발급
  Future<String> issuePresignedUrl(String fileName) => _s3service.issuePresignedUrl(fileName);
}
