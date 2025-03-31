import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/feature/boardgame/screen/BoardGameDetailScreen.dart';
import 'package:jamesboard/feature/boardgame/screen/ListBoardGameCategory.dart';
import 'package:jamesboard/main.dart';
import 'package:provider/provider.dart';
import '../../../theme/Colors.dart';
import '../../../widget/image/ImageCommonGameCard.dart';
import '../viewmodel/BoardGameViewModel.dart';
import '../viewmodel/CategoryGameViewModel.dart';

class ListHomeHorizontalGame extends StatefulWidget {
  final String title;
  final String updateCategory;
  final Function(String, String) updateFilter;
  final Map<String, String> selectedFilters;
  final Map<String, dynamic> queryParameters;

  const ListHomeHorizontalGame({
    Key? key,
    required this.title,
    required this.updateCategory,
    required this.updateFilter,
    required this.selectedFilters,
    required this.queryParameters,
  }) : super(key: key);

  @override
  State<ListHomeHorizontalGame> createState() => _ListHomeHorizontalGameState();
}

class _ListHomeHorizontalGameState extends State<ListHomeHorizontalGame> {
  late BoardGameViewModel viewModel;

  @override
  void initState() {
    super.initState();
    final categoryViewModel =
        Provider.of<CategoryGameViewModel>(context, listen: false);
    viewModel = categoryViewModel.getCategoryViewModel(widget.title);
    viewModel.getBoardGamesForCategory(widget.queryParameters);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<BoardGameViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: mainGold),
            );
          }

          final games = viewModel.games;

          return Container(
            margin: EdgeInsets.only(top: 32, left: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListBoardGameCategory(
                          title: widget.title,
                          updateCategory: widget.updateCategory,
                          updateFilter: widget.updateFilter,
                          selectedFilters: widget.selectedFilters,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: FontString.pretendardMedium,
                          color: mainWhite,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: mainWhite, size: 32),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 160, // ListView의 높이
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      final game = games[index];
                      return Container(
                        margin: EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BoardGameDetailScreen()),
                            );
                          },
                          child: ImageCommonGameCard(imageUrl: game.gameImage),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
