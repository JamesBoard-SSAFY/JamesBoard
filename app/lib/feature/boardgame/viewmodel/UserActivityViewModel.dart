import 'package:flutter/material.dart';
import 'package:jamesboard/datasource/model/response/user/UserActivityDetailResponse.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/repository/UserActivityRepository.dart';

import '../../../datasource/model/request/user/UserActivityPatchRequest.dart';
import '../../../datasource/model/request/user/UserActivityRequest.dart';
import '../../../datasource/model/response/user/UserActivityResponse.dart';

class UserActivityViewModel extends ChangeNotifier {
  final UserActivityRepository _repository;
  bool _isLoading = false;
  String? _errorMessage;
  UserActivityDetailResponse? _userActivityDetail;

  UserActivityViewModel(this._repository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserActivityDetailResponse? get userActivityDetail => _userActivityDetail;

  Future<bool> addUserActivity(UserActivityRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    logger.d("addUserActivity: addUserActivity");

    try {
      final int result = await _repository.addUserActivity(request);

      logger.d("result: ${result}");

      return true;
    } catch (e) {
      _errorMessage = 'Failed to add user activity: $e';

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> checkUserActivity({
    required int userId,
    required int gameId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    logger.d("checkUserActivity: Checking user activity");

    try {
      final List<UserActivityResponse> activities =
          await _repository.getUserActivity(userId, gameId);

      logger.d("Activities length: ${activities.length}");

      if (activities.isNotEmpty) {
        return activities[0].userActivityId;
      } else {
        return 0;
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch user activity: $e';
      return 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUserActivityRating({
    required int userActivityId,
    required UserActivityPatchRequest request,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    logger.d("updateUserActivityRating: Checking user activity");

    try {
      final id = await _repository.updateUserActivityRating(
        userActivityId,
        request,
      );

      logger.d("updateUserActivityRating: ${id}");

      return id > 0;
    } catch (e) {
      _errorMessage = 'Failed to fetch updateUserActivityRating: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUserActivityDetail({
    required int userId,
    required int gameId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userActivityDetail =
          await _repository.getUserActivityDetail(userId, gameId);
      logger.d(
          "getUserActivityDetail rating : ${_userActivityDetail!.userActivityRating}");
    } catch (e) {
      _errorMessage = 'Failed to fetch updateUserActivityRating: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
