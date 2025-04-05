import 'package:flutter/material.dart';
import 'package:jamesboard/feature/boardgame/widget/skeleton/ItemRecommendBoardGameInfoSkeleton.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/view/KeepAliveView.dart';
import 'package:provider/provider.dart';
import '../../../repository/BoardGameRepository.dart';
import '../viewmodel/BoardGameViewModel.dart';
import '../widget/ItemRecommendBoardGameInfo.dart';
import 'BoardGameDetailScreen.dart';

class RecommendGameScreen extends StatelessWidget {
  const RecommendGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardGameViewModel(BoardGameRepository.create())
        ..getRecommendedGames(),
      child: Consumer<BoardGameViewModel>(
        builder: (context, viewModel, child) {
          final isLoading = viewModel.isLoading;

          return isLoading
              ? ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  itemCount: 3,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ItemRecommendBoardGameInfoSkeleton(),
                  ),
                )
              : ListView.builder(
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
                              vertical: 16, horizontal: 20),
                          child: ItemRecommendBoardGameInfo(
                            gameId: game.gameId,
                            imageUrl: game.gameImage,
                            gameName: game.gameTitle,
                            gameCategory: game.gameCategory,
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
