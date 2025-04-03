import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/dummy/AppDummyData.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../../../widget/button/ButtonCommonFilter.dart';
import '../../../widget/bottomsheet/BottomSheetCommonFilter.dart';
import '../../../widget/image/ImageCommonGameCard.dart';
import '../viewmodel/BoardGameViewModel.dart';
import '../viewmodel/CategoryGameViewModel.dart';
import 'BoardGameDetailScreen.dart';

class ListBoardGameCategoryPage extends StatefulWidget {
  final Function(String, String) updateFilter;
  final String title;
  final String updateCategory;
  final Map<String, dynamic> queryParameters;

  const ListBoardGameCategoryPage({
    super.key,
    required this.title,
    required this.updateFilter,
    required this.updateCategory,
    required this.queryParameters,
  });

  @override
  State<ListBoardGameCategoryPage> createState() =>
      _ListBoardGameCategoryPageState();
}

class _ListBoardGameCategoryPageState extends State<ListBoardGameCategoryPage> {
  late Map<String, dynamic> queryParameters;
  late BoardGameViewModel viewModel;

  Map<String, dynamic> buildRequestQueryParameters(
      Map<String, dynamic> queryParameters) {
    Map<String, dynamic> params = {};

    if (queryParameters.containsKey('difficulty')) {
      params['difficulty'] =
          AppDummyData.difficultyMap[queryParameters['difficulty']];
    }

    if (queryParameters.containsKey('minPlayers')) {
      params['minPlayers'] =
          AppDummyData.minPlayersMap[queryParameters['minPlayers']];
    }

    if (queryParameters.containsKey('category')) {
      params['category'] = queryParameters['category'];
    }

    if (queryParameters.containsKey('playTime')) {
      final List<int>? timeRange =
          AppDummyData.playTimeMap[queryParameters['playTime']];
      if (timeRange != null) {
        params['minPlayTime'] = timeRange[0];
        params['maxPlayTime'] = timeRange[1];
      }
    }

    return params;
  }

  Map<String, dynamic> buildFilterQueryParameters(
      Map<String, dynamic> queryParameters) {
    Map<String, dynamic> params = {};

    if (queryParameters.containsKey('difficulty')) {
      params['difficulty'] =
          AppDummyData.difficultyStrMap[queryParameters['difficulty']];
    }

    if (queryParameters.containsKey('minPlayers')) {
      params['minPlayers'] =
          AppDummyData.minPlayerStrMap[queryParameters['minPlayers']];
    }

    if (queryParameters.containsKey('category')) {
      params['category'] = queryParameters['category'];
    }

    if (queryParameters.containsKey("minPlayTime")) {
      params["playTime"] = queryParameters["minPlayTime"];
    }

    return params;
  }

  void updateQueryParameters(String filterType, dynamic selectedValue) {
    if (selectedValue == AppString.noCare ||
        selectedValue == "본부, 어느 단계든 상관없습니다.") {
      queryParameters.remove(filterType);
    } else {
      queryParameters[filterType] = selectedValue;
    }
    setState(() {});
  }

  void _showFilterBottomSheet(String filterType) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetCommonFilter(
        items: AppDummyData.filterOptions[filterType]!.toList(),
      ),
    );

    if (result != null) {
      updateQueryParameters(filterType, result);

      queryParameters.forEach((key, value) {
        logger.d("queryParameters : key : ${key} value : $value");
      });

      Map<String, dynamic> requestParameters =
          buildRequestQueryParameters(queryParameters);

      requestParameters.forEach((key, value) {
        logger.d("requestParameters : key : ${key} value : $value");
      });

      queryParameters.forEach((key, value) {
        logger.d("queryParameters : key : ${key} value : $value");
      });

      viewModel.getBoardGames(requestParameters);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    final categoryViewModel =
        Provider.of<CategoryGameViewModel>(context, listen: false);
    viewModel = categoryViewModel.getCategoryViewModel("filter");
    viewModel.getBoardGames(widget.queryParameters);

    queryParameters = buildFilterQueryParameters(widget.queryParameters);
  }

  @override
  void dispose() {
    super.dispose();
    widget.queryParameters.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...AppDummyData.filters.map(
                    (filter) {
                      return Container(
                        margin: EdgeInsets.only(right: 16),
                        child: ButtonCommonFilter(
                          text: AppDummyData
                                  .filterDisplayMap[queryParameters[filter]] ??
                              AppDummyData.filterButtonMap[filter]!,
                          onTap: () {
                            logger
                                .d("key : onTap : ${queryParameters[filter]}");

                            _showFilterBottomSheet(filter);
                          },
                          isSelected: queryParameters.containsKey(filter),
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      queryParameters.clear();
                      viewModel.getBoardGames(
                          buildRequestQueryParameters(queryParameters));
                      setState(() {});
                    },
                    child: Text(
                      AppString.clear,
                      style: TextStyle(
                        color: mainWhite,
                        fontSize: 16,
                        fontFamily: FontString.pretendardSemiBold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ChangeNotifierProvider.value(
              value: viewModel,
              child: Consumer<BoardGameViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: mainGold),
                    );
                  }

                  final games = viewModel.games;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: games.length, // ViewModel에서 데이터 사용
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BoardGameDetailScreen(
                                gameId: games[index].gameId,
                              ),
                            ),
                          );
                        },
                        child: ImageCommonGameCard(
                          imageUrl: games[index].gameImage, // ViewModel 데이터 적용
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
