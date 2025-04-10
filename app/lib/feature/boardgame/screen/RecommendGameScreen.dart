import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamesboard/constants/AppData.dart';
import 'package:jamesboard/feature/boardgame/widget/skeleton/ItemRecommendBoardGameInfoSkeleton.dart';
import 'package:jamesboard/repository/LoginRepository.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/view/KeepAliveView.dart';
import 'package:jamesboard/widget/physics/CustomScrollPhysics.dart';
import 'package:provider/provider.dart';
import '../../../repository/BoardGameRepository.dart';
import '../viewmodel/BoardGameViewModel.dart';
import '../widget/ItemRecommendBoardGameInfo.dart';
import 'BoardGameDetailScreen.dart';

class RecommendGameScreen extends StatefulWidget {
  const RecommendGameScreen({super.key});

  @override
  State<RecommendGameScreen> createState() => _RecommendGameScreenState();
}

class _RecommendGameScreenState extends State<RecommendGameScreen> {
  late BoardGameViewModel boardGameViewModel;
  DateTime? currentBackPressTime;

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    if (currentBackPressTime == null ||
        currentTime.difference(currentBackPressTime!) >
            const Duration(seconds: 2)) {
      currentBackPressTime = currentTime;
      Fluttertoast.showToast(
          msg: "'뒤로' 버튼을 한번 더 누르시면 종료됩니다.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xff6E6E6E),
          fontSize: 14,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    return true;

    SystemNavigator.pop();
  }

  void initState() {
    super.initState();
    boardGameViewModel =
        Provider.of<BoardGameViewModel>(context, listen: false);
    boardGameViewModel.getRecommendedGames();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: ChangeNotifierProvider.value(
        value: boardGameViewModel,
        child: Consumer<BoardGameViewModel>(
          builder: (context, viewModel, child) {
            final isLoading = viewModel.isLoading;

            return isLoading
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    itemCount: 3,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ItemRecommendBoardGameInfoSkeleton(),
                    ),
                  )
                : ListView.builder(
                    physics: CustomScrollPhysics(
                        scrollSpeedFactor: AppData.scrollSpeed),
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
      ),
    );
  }
}
