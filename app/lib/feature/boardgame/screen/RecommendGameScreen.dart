import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/view/KeepAliveView.dart';
import 'package:provider/provider.dart';
import '../../../repository/BoardGameRepository.dart';
import '../viewmodel/BoardGameViewModel.dart';
import '../widget/ItemRecommendBoardGameInfo.dart';
import 'BoardGameDetailScreen.dart';

class RecommendGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardGameViewModel(BoardGameRepository.create())
        ..getRecommendedGames(),
      child: Consumer<BoardGameViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage != null) {
            return Center(
                child: Text(
              viewModel.errorMessage!,
              style: TextStyle(
                color: mainWhite,
              ),
            ));
          } else if (viewModel.recommendedGames.isEmpty) {
            return Center(
                child: Text(
              '추천 보드게임이 없습니다.',
              style: TextStyle(
                color: mainWhite,
              ),
            ));
          }
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: viewModel.recommendedGames.length,
            itemBuilder: (context, index) {
              final game = viewModel.recommendedGames[index];
              return KeepAliveView(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BoardGameDetailScreen(
                          gameId: game.gameId,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 20),
                    child: ItemRecommendBoardGameInfo(
                      gameId: game.gameId,
                      imageUrl: game.gameImage,
                      gameName: game.gameTitle,
                      gameCategory: game.gameCategory[0],
                      gameMinPlayer: game.minPlayer,
                      gameMaxPlayer: game.maxPlayer,
                      gameDifficulty: game.difficulty,
                      gamePlayTime: game.playTime,
                      gameDescription: game.gameDescription,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
