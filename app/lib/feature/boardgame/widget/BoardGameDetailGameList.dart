import 'package:flutter/material.dart';
import 'package:jamesboard/util/view/KeepAliveView.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/AppString.dart';
import '../../../theme/Colors.dart';
import '../../../widget/image/ImageCommonGameCard.dart';
import '../screen/BoardGameDetailScreen.dart';
import '../viewmodel/BoardGameViewModel.dart';
import '../viewmodel/CategoryGameViewModel.dart';

class BoardGameDetailGameList extends StatefulWidget {
  final String category;
  const BoardGameDetailGameList({
    super.key,
    required this.category,
  });

  @override
  State<BoardGameDetailGameList> createState() =>
      _BoardGameDetailGameListState();
}

class _BoardGameDetailGameListState extends State<BoardGameDetailGameList> {
  late BoardGameViewModel viewModel;

  @override
  void initState() {
    super.initState();

    final categoryViewModel =
        Provider.of<CategoryGameViewModel>(context, listen: false);

    viewModel = categoryViewModel.getCategoryViewModel(AppString.gameDetailKey);
    viewModel.getBoardGames({AppString.keyCategory: widget.category});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<BoardGameViewModel>(builder: (context, viewModel, child) {
        final isLoading = viewModel.isLoading;
        final games = viewModel.games;

        return Container(
          margin: EdgeInsets.only(
            top: 24,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: isLoading
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: 9, // 로딩 상태일 때 9개의 스켈레톤을 보여줌
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: shimmerBaseColor,
                      highlightColor: shimmerHighlightColor,
                      child: Container(
                        width: 120,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 한 줄에 3개
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: games.length < 30 ? games.length : 30,
                  itemBuilder: (context, index) {
                    return KeepAliveView(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BoardGameDetailScreen(
                                key: UniqueKey(),
                                gameId: games[index].gameId,
                              ),
                            ),
                          );
                        },
                        child: ImageCommonGameCard(
                          imageUrl: games[index].gameImage,
                        ),
                      ),
                    );
                  },
                ),
        );
      }),
    );
  }
}
