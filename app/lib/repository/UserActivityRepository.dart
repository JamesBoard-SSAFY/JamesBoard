import 'package:jamesboard/datasource/api/UserActivityService.dart';

import '../datasource/model/request/user/UserActivityRequest.dart';
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
}
