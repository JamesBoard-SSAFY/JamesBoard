import 'package:flutter/material.dart';
import 'package:jamesboard/feature/boardgame/viewmodel/BoardGameViewModel.dart';

import '../../../repository/BoardGameRepository.dart';
import '../../../repository/RecentSearchRepository.dart';

class CategoryGameViewModel extends ChangeNotifier {
  final BoardGameRepository _repository;

  final Map<String, BoardGameViewModel> _gameViewModels = {};

  CategoryGameViewModel(this._repository);

  BoardGameViewModel getCategoryViewModel(String category,
      [RecentSearchRepository? recentSearchRepository]) {
    if (!_gameViewModels.containsKey(category)) {
      _gameViewModels[category] =
          BoardGameViewModel(_repository, recentSearchRepository);
    }
    return _gameViewModels[category]!;
  }
}
