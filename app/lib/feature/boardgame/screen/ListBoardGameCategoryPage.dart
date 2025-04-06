import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppData.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/FilterUtil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../main.dart';
import '../../../widget/button/ButtonCommonFilter.dart';
import '../../../widget/bottomsheet/BottomSheetCommonFilter.dart';
import '../../../widget/image/ImageCommonGameCard.dart';
import '../../../widget/physics/CustomScrollPhysics.dart';
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

  void updateQueryParameters(String filterType, dynamic selectedValue) {
    if (selectedValue == AppString.noCare ||
        selectedValue == AppString.difficultyAny) {
      queryParameters.remove(filterType);
    } else {
      queryParameters[filterType] = selectedValue;
    }
    setState(() {});
  }

  void _showFilterBottomSheet(String filterType, String filterValue) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BottomSheetCommonFilter(
        items: AppData.filterOptions[filterType]!.toList(),
        initialValue: filterValue,
      ),
    );

    if (result != null) {
      updateQueryParameters(filterType, result);

      queryParameters.forEach((key, value) {
        logger.d("queryParameters : key : ${key} value : $value");
      });

      Map<String, dynamic> requestParameters =
          FilterUtil.buildRequestQueryParameters(queryParameters);

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
    viewModel = categoryViewModel.getCategoryViewModel(AppString.keyFilter);
    viewModel.getBoardGames(widget.queryParameters);

    queryParameters =
        FilterUtil.buildFilterQueryParameters(widget.queryParameters);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...AppData.filters.map(
                  (filter) {
                    return Container(
                      margin: EdgeInsets.only(right: 16),
                      child: ButtonCommonFilter(
                        text:
                            AppData.filterDisplayMap[queryParameters[filter]] ??
                                AppData.filterButtonMap[filter]!,
                        onTap: () {
                          _showFilterBottomSheet(
                            filter,
                            queryParameters[filter] ?? "",
                          );
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
                        FilterUtil.buildRequestQueryParameters(
                            queryParameters));
                    setState(() {});
                  },
                  child: Text(
                    AppString.clear,
                    style: TextStyle(
                        color: mainGrey,
                        fontSize: 16,
                        fontFamily: FontString.pretendardSemiBold,
                        decoration: TextDecoration.underline,
                        decorationColor: mainGrey,
                        decorationThickness: 1),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        ChangeNotifierProvider.value(
          value: viewModel,
          child: Consumer<BoardGameViewModel>(
            builder: (context, viewModel, child) {
              final isLoading = viewModel.isLoading;
              final games = viewModel.games;

              if (!isLoading && games.isEmpty) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppString.noContentGames,
                        style: TextStyle(
                          color: mainWhite,
                          fontSize: 24,
                          fontFamily: FontString.pretendardBold,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Expanded(
                child: SingleChildScrollView(
                  physics: CustomScrollPhysics(scrollSpeedFactor: 0.4),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: isLoading ? 15 : games.length,
                      itemBuilder: (context, index) {
                        return isLoading
                            ? Shimmer.fromColors(
                                baseColor: shimmerBaseColor,
                                highlightColor: shimmerHighlightColor,
                                child: Container(
                                  width: 120,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BoardGameDetailScreen(
                                        gameId: games[index].gameId,
                                      ),
                                    ),
                                  );
                                },
                                child: ImageCommonGameCard(
                                  imageUrl: games[index]
                                      .gameImage, // ViewModel 데이터 적용
                                ),
                              );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
