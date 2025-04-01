import 'package:flutter/material.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/repository/UserActivityRepository.dart';

import '../../../datasource/model/request/user/UserActivityRequest.dart';

class UserActivityViewModel extends ChangeNotifier {
  final UserActivityRepository _repository;
  bool _isLoading = false;
  String? _errorMessage;

  UserActivityViewModel(this._repository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
}
