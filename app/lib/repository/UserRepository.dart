import 'package:jamesboard/datasource/api/UserService.dart';
import 'package:jamesboard/util/DioProviderUtil.dart';

class UserRepository {
  final UserService _service;

  UserRepository._(this._service);

  factory UserRepository.create() {
    final service = UserService(DioProviderUtil.dio);
    return UserRepository._(service);
  }

  // 유저 선호 게임 조회
  Future<int> checkUserPreferBoardGame(int userId) =>
      _service.checkUserPreferBoardGame(userId);
}
