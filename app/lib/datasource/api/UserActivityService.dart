import 'package:dio/dio.dart';
import 'package:jamesboard/main.dart';
import 'package:retrofit/retrofit.dart';

import '../model/request/user/UserActivityRequest.dart';

part 'UserActivityService.g.dart';

@RestApi(baseUrl: "https://j12d205.p.ssafy.io/")
abstract class UserActivityService {
  factory UserActivityService(Dio dio, {String baseUrl}) = _UserActivityService;

  @POST("api/user-activity")
  Future<int> addUserActivity(@Body() UserActivityRequest request);
}
