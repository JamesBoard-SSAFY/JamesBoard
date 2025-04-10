import 'package:dio/dio.dart';
import 'package:jamesboard/datasource/model/response/user/UserActivityDetailResponse.dart';
import 'package:retrofit/retrofit.dart';

import '../../main.dart';
import '../model/request/user/UserActivityRequest.dart';
import '../model/request/user/UserActivityPatchRequest.dart';
import '../model/response/user/UserActivityResponse.dart';

part 'UserActivityService.g.dart';

@RestApi(baseUrl: "https://j12d205.p.ssafy.io/")
abstract class UserActivityService {
  factory UserActivityService(Dio dio, {String baseUrl}) = _UserActivityService;

  @GET("api/user-activity")
  Future<List<UserActivityResponse>> getUserActivity(
    @Query("userId") int userId,
    @Query("gameId") int gameId,
  );

  @POST("api/user-activity")
  Future<int> addUserActivity(@Body() UserActivityRequest request);

  @PATCH("api/user-activity/{userActivityId}")
  Future<int> updateUserActivityRating(
    @Path("userActivityId") int userActivityId,
    @Body() UserActivityPatchRequest request,
  );

  @GET("api/user-activity/detail")
  Future<UserActivityDetailResponse> getUserActivityDetail(
    @Query("userId") int userId,
    @Query("gameId") int gameId,
  );
}
