import 'package:jamesboard/datasource/api/UserActivityService.dart';

import '../datasource/model/request/user/UserActivityPatchRequest.dart';
import '../datasource/model/request/user/UserActivityRequest.dart';
import '../datasource/model/response/user/UserActivityDetailResponse.dart';
import '../datasource/model/response/user/UserActivityResponse.dart';
import '../util/DioProviderUtil.dart';

class UserActivityRepository {
  final UserActivityService _service;

  UserActivityRepository._(this._service);

  factory UserActivityRepository.create() {
    final dio = DioProviderUtil.dio;

    final service = UserActivityService(dio);
    return UserActivityRepository._(service);
  }

  Future<int> addUserActivity(UserActivityRequest request) =>
      _service.addUserActivity(request);

  Future<List<UserActivityResponse>> getUserActivity(int userId, int gameId) =>
      _service.getUserActivity(userId, gameId);

  Future<int> updateUserActivityRating(
    int userActivityId,
    UserActivityPatchRequest request,
  ) =>
      _service.updateUserActivityRating(userActivityId, request);

  Future<UserActivityDetailResponse> getUserActivityDetail(
          int userId, int gameId) =>
      _service.getUserActivityDetail(userId, gameId);
}
