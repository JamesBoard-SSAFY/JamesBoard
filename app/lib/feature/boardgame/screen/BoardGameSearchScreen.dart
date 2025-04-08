import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/datasource/model/local/AppDatabase.dart';
import 'package:jamesboard/feature/boardgame/screen/BoardGameDetailScreen.dart';
import 'package:jamesboard/feature/boardgame/viewmodel/BoardGameViewModel.dart';
import 'package:jamesboard/feature/mission/viewmodel/MissionViewModel.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/repository/RecentSearchRepository.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/BoardGameSearchPurpose.dart';
import 'package:jamesboard/widget/image/ImageCommonGameCard.dart';
import 'package:jamesboard/widget/item/ItemCommonRecentSearch.dart';
import 'package:jamesboard/widget/physics/CustomScrollPhysics.dart';
import 'package:jamesboard/widget/searchbar/SearchBarCommonTitle.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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

  bool _hasSearched = false;

  final FocusNode _searchFocusNode = FocusNode();

  void _searchBoardGames() async {
    final keyword = _searchController.text.trim();

    if (keyword.isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _hasSearched = true;
    });

    if (widget.purpose == BoardGameSearchPurpose.fromHome) {
      await boardGameViewModel.saveRecentSearch(keyword);
    }

    boardGameViewModel.getBoardGames({'boardGameName': keyword}, true);
  }

  @override
  void initState() {
    super.initState();

    final categoryViewModel =
        Provider.of<CategoryGameViewModel>(context, listen: false);

    boardGameViewModel = categoryViewModel.getCategoryViewModel(
        'boardGameName', RecentSearchRepository(AppDatabase()));
    boardGameViewModel.clearSearchResults();

    boardGameViewModel.getRecentSearches();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 검색 바 영역
                SearchBarCommonTitle(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onSubmitted: (_) => _searchBoardGames(),
                ),
                const SizedBox(height: 20),

                // 검색 결과 영역
                Expanded(
                  child: ChangeNotifierProvider<BoardGameViewModel>.value(
                    value: boardGameViewModel,
                    child: Consumer<BoardGameViewModel>(
                      builder: (context, viewModel, _) {
                        // 스켈레톤 처리.
                        if (viewModel.isLoading) {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 3 / 4,
                            ),
                            itemCount: 30,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: shimmerBaseColor,
                                highlightColor: shimmerHighlightColor,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: mainWhite,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                          );
                        }

                        final hasSearchResults = viewModel.games.isNotEmpty;
                        final hasRecentSearches =
                            viewModel.recentSearches.isNotEmpty;

                        // 검색 결과가 있다면 → 그리드뷰
                        if (hasSearchResults) {
                          return GridView.builder(
                            physics:
                                CustomScrollPhysics(scrollSpeedFactor: 0.4),
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
                                onTap: () async {
                                  final selectedGameId = game.gameId;
                                  final selectedGameTitle = game.gameTitle;
                                  final selectedGamePlayTime = game.playTime;

                                  if (widget.purpose ==
                                      BoardGameSearchPurpose.fromHome) {
                                    viewModel.setSelectedGameId(
                                        gameId: selectedGameId);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BoardGameDetailScreen(
                                            gameId: selectedGameId),
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

                                    Navigator.pop(context);
                                  }
                                },
                                child: ImageCommonGameCard(
                                  imageUrl: game.gameImage ?? '',
                                ),
                              );
                            },
                          );
                        }

                        // 검색 결과가 없고 최근 검색어가 있으면 → 최근 검색어 리스트
                        if (!_hasSearched) {
                          if (hasRecentSearches &&
                              widget.purpose ==
                                  BoardGameSearchPurpose.fromHome) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppString.recentSearch,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: FontString.pretendardSemiBold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: viewModel.recentSearches.length,
                                    itemBuilder: (context, index) {
                                      final recent =
                                          viewModel.recentSearches[index];

                                      return ItemCommonRecentSearch(
                                        title: recent.keyword,
                                        onTap: () {
                                          _searchController.text =
                                              recent.keyword;
                                          _searchBoardGames();
                                        },
                                        onDelete: () {
                                          viewModel
                                              .deleteRecentSearch(recent.id);
                                        },
                                        iconPath: IconPath.close,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Center(
                              child: Text(
                                AppString.searchInput,
                                style: TextStyle(
                                  color: mainWhite,
                                  fontFamily: FontString.pretendardSemiBold,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          }
                        } else {
                          return Center(
                            child: Text(
                              AppString.noSearchResult,
                              style: TextStyle(
                                color: mainWhite,
                                fontFamily: FontString.pretendardSemiBold,
                                fontSize: 20,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
