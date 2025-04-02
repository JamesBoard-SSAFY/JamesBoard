import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/feature/boardgame/screen/BoardGameDetailScreen.dart';
import 'package:jamesboard/feature/boardgame/viewmodel/BoardGameViewModel.dart';
import 'package:jamesboard/feature/mission/viewmodel/MissionViewModel.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/BoardGameSearchPurpose.dart';
import 'package:jamesboard/widget/image/ImageCommonGameCard.dart';
import 'package:jamesboard/widget/item/ItemCommonRecentSearch.dart';
import 'package:jamesboard/widget/searchbar/SearchBarCommonTitle.dart';
import 'package:provider/provider.dart';

class BoardGameSearchScreen extends StatefulWidget {
  final BoardGameSearchPurpose purpose;

  const BoardGameSearchScreen({
    super.key,
    required this.purpose,
  });

  @override
  State<BoardGameSearchScreen> createState() => _BoardGameSearchScreenState();
}

class _BoardGameSearchScreenState extends State<BoardGameSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _searchBoardGames(BuildContext context) {
    final keyword = _searchController.text.trim();

    if (keyword.isEmpty) return;

    final viewModel = context.read<BoardGameViewModel>();
    viewModel.getBoardGames({'boardgameName': keyword});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 검색 바 영역
              SearchBarCommonTitle(
                controller: _searchController,
                onSubmitted: (_) => _searchBoardGames(context),
              ),
              const SizedBox(height: 20),

              // 검색 결과 영역
              Expanded(
                child: Consumer<BoardGameViewModel>(
                  builder: (context, viewModel, _) {
                    if (viewModel.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: viewModel.games.length,
                      itemBuilder: (context, index) {
                        final game = viewModel.games[index];
                        return GestureDetector(
                          onTap: () {
                            final selectedGameId = game.gameId;
                            final selectedGameTitle = game.gameTitle;

                            // 홈에서 검색한 경우
                            if (widget.purpose ==
                                BoardGameSearchPurpose.fromHome) {
                              final boardGameViewModel =
                                  context.read<BoardGameViewModel>();
                              boardGameViewModel.setSelectedGameId(
                                gameId: selectedGameId,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BoardGameDetailScreen(
                                    gameId: game.gameId,
                                  ),
                                ),
                              );
                            }
                            // 아카이브 등록에서 검색한 경우
                            else if (widget.purpose ==
                                BoardGameSearchPurpose.fromMission) {
                              final missionViewModel =
                                  context.read<MissionViewModel>();

                              missionViewModel.setSelectedBoardGame(
                                gameId: game.gameId,
                                gameTitle: game.gameTitle,
                                gamePlayTime: game.playTime,
                              );

                              logger.d(
                                  'BoardGameSearchScreen에서 MissionViewModel.gameTitle : ${missionViewModel.selectedGameTitle}');

                              Navigator.pop(context);
                            }
                          },
                          child: ImageCommonGameCard(
                              imageUrl: game.gameImage ?? ''),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
