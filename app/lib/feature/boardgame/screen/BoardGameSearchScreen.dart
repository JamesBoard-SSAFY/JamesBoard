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

import '../viewmodel/CategoryGameViewModel.dart';

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
  late BoardGameViewModel boardGameViewModel;

  void _searchBoardGames() {
    final keyword = _searchController.text.trim();

    if (keyword.isEmpty) return;

    boardGameViewModel.getBoardGames({'boardGameName': keyword});
  }

  @override
  void initState() {
    super.initState();

    final categoryViewModel =
        Provider.of<CategoryGameViewModel>(context, listen: false);

    boardGameViewModel =
        categoryViewModel.getCategoryViewModel('boardGameName');
    boardGameViewModel.clearSearchResults();
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
                onSubmitted: (_) => _searchBoardGames(),
              ),
              const SizedBox(height: 20),

              // 검색 결과 영역
              Expanded(
                child: ChangeNotifierProvider<BoardGameViewModel>.value(
                  value: boardGameViewModel,
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
                          logger.d('검색 결과 : $game');

                          return GestureDetector(
                            onTap: () {
                              final selectedGameId = game.gameId;
                              final selectedGameTitle = game.gameTitle;
                              final selectedGamePlayTime = game.playTime;

                              if (widget.purpose ==
                                  BoardGameSearchPurpose.fromHome) {
                                viewModel.setSelectedGameId(
                                  gameId: selectedGameId,
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BoardGameDetailScreen(
                                      gameId: selectedGameId,
                                    ),
                                  ),
                                );
                              } else if (widget.purpose ==
                                  BoardGameSearchPurpose.fromMission) {
                                final missionViewModel =
                                    context.read<MissionViewModel>();

                                missionViewModel.setSelectedBoardGame(
                                  gameId: selectedGameId,
                                  gameTitle: selectedGameTitle,
                                  gamePlayTime: selectedGamePlayTime,
                                );

                                logger.d(
                                    'BoardGameSearchScreen에서 MissionViewModel.gameTitle : ${missionViewModel.selectedGameTitle}');

                                Navigator.pop(context);
                              }
                            },
                            child: ImageCommonGameCard(
                              imageUrl: game.gameImage ?? '',
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
