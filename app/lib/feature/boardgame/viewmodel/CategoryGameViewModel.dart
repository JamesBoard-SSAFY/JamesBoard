import 'package:flutter/material.dart';
import 'package:jamesboard/feature/boardgame/viewmodel/BoardGameViewModel.dart';
import 'package:jamesboard/repository/LoginRepository.dart';

import '../../../repository/BoardGameRepository.dart';
import '../../../repository/RecentSearchRepository.dart';

class CategoryGameViewModel extends ChangeNotifier {
  final BoardGameRepository _repository;
  final LoginRepository _loginRepository;

  final Map<String, BoardGameViewModel> _gameViewModels = {};

  CategoryGameViewModel(this._repository, this._loginRepository);

  BoardGameViewModel getCategoryViewModel(String category,
      [RecentSearchRepository? recentSearchRepository]) {
    if (!_gameViewModels.containsKey(category)) {
      _gameViewModels[category] = BoardGameViewModel(
          _repository, _loginRepository, recentSearchRepository);
    }
    return _gameViewModels[category]!;
  }
}
