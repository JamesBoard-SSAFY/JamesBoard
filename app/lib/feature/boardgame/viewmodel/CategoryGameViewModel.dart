import 'package:flutter/material.dart';
import 'package:jamesboard/feature/boardgame/viewmodel/BoardGameViewModel.dart';

import '../../../repository/BoardGameRepository.dart';

class CategoryGameViewModel extends ChangeNotifier {
  final BoardGameRepository _repository;

  // 카테고리별 ViewModel을 저장하는 Map
  final Map<String, BoardGameViewModel> _gameViewModels = {};

  CategoryGameViewModel(this._repository);

  BoardGameViewModel getCategoryViewModel(String category) {
    if (!_gameViewModels.containsKey(category)) {
      _gameViewModels[category] = BoardGameViewModel(_repository);
    }
    return _gameViewModels[category]!;
  }
}
