import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/feature/boardgame/screen/BoardGameDetailScreen.dart';
import 'package:jamesboard/feature/boardgame/screen/ListBoardGameCategory.dart';
import 'package:jamesboard/util/view/KeepAliveView.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../theme/Colors.dart';
import '../../../widget/image/ImageCommonGameCard.dart';
import '../viewmodel/BoardGameViewModel.dart';
import '../viewmodel/CategoryGameViewModel.dart';

class ListHomeHorizontalGame extends StatefulWidget {
  final String title;
  final String updateCategory;
  final Function(String, String) updateFilter;
  final Map<String, dynamic> queryParameters;

  const ListHomeHorizontalGame({
    Key? key,
    required this.title,
    required this.updateCategory,
    required this.updateFilter,
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
    viewModel.getBoardGames(widget.queryParameters);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<BoardGameViewModel>(
        builder: (context, viewModel, child) {
          final isLoading = viewModel.isLoading;
          final games = viewModel.games;

          return Container(
            margin: EdgeInsets.only(top: 32, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListBoardGameCategory(
                          queryParameters: widget.queryParameters,
                          title: widget.title,
                          updateCategory: widget.updateCategory,
                          updateFilter: widget.updateFilter,
                        ),
                      ),
                    );
                  },
                  child: isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[700]!,
                              highlightColor: Colors.grey[500]!,
                              child: Container(
                                width: widget.title.length *
                                    14.0, // 대략적인 텍스트 크기 유지
                                height: 24, // 폰트 크기에 맞춰 설정
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        )
                      : Row(
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
                            Icon(Icons.chevron_right,
                                color: mainWhite, size: 32),
                          ],
                        ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 160, // ListView의 높이
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: isLoading ? 5 : games.length, // 로딩 중이면 5개 스켈레톤
                    itemBuilder: (context, index) {
                      return KeepAliveView(
                        child: Container(
                          margin: EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: isLoading
                                ? null
                                : () {
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
                            child: isLoading
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[700]!,
                                    highlightColor: Colors.grey[500]!,
                                    child: Container(
                                      width: 120,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  )
                                : ImageCommonGameCard(
                                    imageUrl: games[index].gameImage),
                          ),
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
