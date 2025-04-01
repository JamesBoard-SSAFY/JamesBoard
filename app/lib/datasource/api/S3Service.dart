import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'S3Service.g.dart';

@RestApi(baseUrl: "https://j12d205.p.ssafy.io/")
abstract class S3Service {
  factory S3Service(Dio dio, {String baseUrl}) = _S3Service;

  // presigned url 발급
  @POST("/api/s3/presigned-url")
  Future<String> issuePresignedUrl(
    @Query("fileName") String fileName,
  );
}
