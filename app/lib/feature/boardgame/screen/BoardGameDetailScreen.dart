import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/CommonUtils.dart';
import 'package:jamesboard/widget/button/ButtonCommonGameTag.dart';
import 'package:jamesboard/widget/button/ButtonCommonPrimaryBottom.dart';
import 'package:provider/provider.dart';

import '../../../constants/AppString.dart';
import '../../../util/BottomSheetUtil.dart';
import '../viewmodel/BoardGameViewModel.dart';
import '../widget/BoardGameDetailGameList.dart';

class BoardGameDetailScreen extends StatefulWidget {
  final int gameId;

  const BoardGameDetailScreen({super.key, required this.gameId});
  @override
  State<BoardGameDetailScreen> createState() => _BoardGameDetailScreenState();
}

class _BoardGameDetailScreenState extends State<BoardGameDetailScreen> {
  late BoardGameViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<BoardGameViewModel>(context, listen: false);
    viewModel.getBoardGameDetail(widget.gameId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: mainBlack,
        body: SafeArea(
          child: Consumer<BoardGameViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return Center(
                    child: CircularProgressIndicator(color: mainGold));
              }

              final boardGameDetail = viewModel.boardGameDetail;

              if (boardGameDetail == null) {
                return Center(
                  child: Text(
                    "게임 정보가 없습니다.",
                    style: TextStyle(
                      color: mainWhite,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          child: Image.network(
                            boardGameDetail
                                .gameImage, // Image URL from view model
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: secondaryBlack,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                color: mainWhite,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent, // 위쪽은 투명
                                  shadowBlack.withOpacity(0.8), // 아래로 갈수록 진하게
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  boardGameDetail.gameTitle,
                                  style: TextStyle(
                                    color: mainWhite,
                                    fontSize: 44,
                                    fontFamily: FontString.pretendardBold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      IconPath.starSelected,
                                      width: 24,
                                      height: 24,
                                      color: mainGold,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "${boardGameDetail.gameRating}", // Rating from view model
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: FontString.pretendardMedium,
                                        color: mainGold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              child: ButtonCommonGameTag(
                                text: "${boardGameDetail.gameMinAge}세",
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              child: ButtonCommonGameTag(
                                text: '${boardGameDetail.gameYear}년',
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              child: ButtonCommonGameTag(
                                text: CommonUtils.getDifficulty(
                                  boardGameDetail.difficulty,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              child: ButtonCommonGameTag(
                                text: CommonUtils.getAgeInfo(
                                  boardGameDetail.minPlayers,
                                  boardGameDetail.maxPlayers,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              child: ButtonCommonGameTag(
                                text: '${boardGameDetail.playTime}분',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        top: 12,
                      ),
                      child: Text(
                        boardGameDetail.gameCategories.join(" • "),
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontString.pretendardMedium,
                          color: mainGrey,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 24,
                      ),
                      child: ButtonCommonPrimaryBottom(
                        text: AppString.evaluation,
                        onPressed: () {
                          BottomSheetUtil.showRatingBottomSheet(
                            context,
                            gameId: boardGameDetail.gameId,
                          );
                        },
                        disableWithOpacity: false,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        top: 24,
                        right: 20,
                      ),
                      child: Text(
                        boardGameDetail.description,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: FontString.pretendardMedium,
                            color: mainWhite),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        right: 20,
                        top: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              BottomSheetUtil.showBoardGameDetailBottomSheet(
                                context,
                                boardGameDetail: boardGameDetail,
                              );
                            },
                            child: Text(
                              "더보기",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: FontString.pretendardMedium,
                                color: mainGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 24,
                        left: 20,
                        right: 20,
                      ),
                      child: Divider(
                        color: mainGrey,
                        thickness: 1, // 두께 설정
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 24,
                        left: 20,
                        right: 20,
                      ),
                      child: Text(
                        AppString.similarMission,
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: FontString.pretendardBold,
                          color: mainWhite,
                        ),
                      ),
                    ),
                    BoardGameDetailGameList(
                      category: boardGameDetail.gameCategories[Random()
                          .nextInt(boardGameDetail.gameCategories.length)],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
