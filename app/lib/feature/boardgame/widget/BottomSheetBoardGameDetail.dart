import 'dart:core';

import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/feature/boardgame/widget/DividerBottomSheetBoardGameDetail.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/CommonUtils.dart';
import 'package:provider/provider.dart';

import '../viewmodel/BoardGameViewModel.dart';
import '../viewmodel/CategoryGameViewModel.dart';

class BottomSheetBoardGameDetail extends StatefulWidget {
  final int gameId;
  final String gameTitle;
  final int gameReleaseYear;
  final List<String> gameCategories;
  final List<String> gameThemes;
  final double gameAverageRating;
  final int gameDifficulty;
  final int gameAge;
  final int gameMinPlayer;
  final int gameMaxPlayer;
  final int gamePlayTime;
  final String gameDescription;
  final String gamePublisher;
  final List<String> gameDesigners;
  final ScrollController scrollController; // 추가

  const BottomSheetBoardGameDetail({
    super.key,
    required this.gameId,
    required this.gameTitle,
    required this.gameReleaseYear,
    required this.gameCategories,
    required this.gameThemes,
    required this.gameAverageRating,
    required this.gameDifficulty,
    required this.gameAge,
    required this.gameMinPlayer,
    required this.gameMaxPlayer,
    required this.gamePlayTime,
    required this.gameDescription,
    required this.gamePublisher,
    required this.gameDesigners,
    required this.scrollController,
  });

  @override
  State<BottomSheetBoardGameDetail> createState() =>
      _BottomSheetBoardGameDetailState();
}

class _BottomSheetBoardGameDetailState
    extends State<BottomSheetBoardGameDetail> {
  late BoardGameViewModel ratingViewModel;

  // key 영역 중 가장 긴 값.
  double _getMaxKeyWidth(
      List<Map<String, dynamic>> infoList, BuildContext context) {
    double maxWidth = 0;

    for (var info in infoList) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: info['title'],
          style: TextStyle(
            fontSize: 16,
            fontFamily: FontString.pretendardMedium,
            color: mainWhite,
          ),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();

      if (textPainter.width > maxWidth) {
        maxWidth = textPainter.width;
      }
    }

    return maxWidth;
  }

  @override
  void initState() {
    super.initState();

    final categoryViewModel =
        Provider.of<CategoryGameViewModel>(context, listen: false);
    ratingViewModel =
        categoryViewModel.getCategoryViewModel("${widget.gameId}rating");

    ratingViewModel.getBoardGameDetail(widget.gameId);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gameDefaultInfo = [
      {'title': AppString.releaseYear, 'value': widget.gameReleaseYear},
      {'title': AppString.genre, 'value': widget.gameCategories},
      {'title': AppString.theme, 'value': widget.gameThemes},
      {
        'title': AppString.rating,
        'value': CommonUtils.roundToTwoDecimalPlaces(widget.gameAverageRating)
      },
      {'title': AppString.difficulty, 'value': widget.gameDifficulty},
      {'title': AppString.age, 'value': widget.gameAge},
      {'title': AppString.minPlayers, 'value': widget.gameMinPlayer},
      {'title': AppString.maxPlayers, 'value': widget.gameMaxPlayer},
      {'title': AppString.averagePlayTime, 'value': widget.gamePlayTime},
    ];

    final List<Map<String, dynamic>> gameMakerInfo = [
      {'title': AppString.publisher, 'value': widget.gamePublisher},
      {'title': AppString.designer, 'value': widget.gameDesigners},
    ];

    final double maxKeyWidth = [
      _getMaxKeyWidth(gameDefaultInfo, context),
      _getMaxKeyWidth(gameMakerInfo, context),
    ].reduce((a, b) => a > b ? a : b);

    return ChangeNotifierProvider.value(
      value: ratingViewModel,
      child: Consumer<BoardGameViewModel>(
        builder: (context, viewModel, child) {
          final boardGameDetail = viewModel.boardGameDetail;
          final double updatedRating =
              boardGameDetail?.gameRating ?? widget.gameAverageRating;

          gameDefaultInfo[3]['value'] =
              CommonUtils.roundToTwoDecimalPlaces(updatedRating);

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: secondaryBlack,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 크기 조절 핸들 추가
                SizedBox(
                  height: 20,
                ),

                // 스크롤 가능 영역
                Expanded(
                  child: SingleChildScrollView(
                    controller: widget.scrollController,
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 3,
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 게임 이름
                              Text(
                                widget.gameTitle,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: FontString.pretendardBold,
                                  color: mainWhite,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // 기본 정보 섹션
                              _buildSectionTitle(AppString.basicInfo),
                              const SizedBox(height: 4),
                              ...gameDefaultInfo.map((info) => Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: _buildSectionInfo(info['title'],
                                        info['value'], maxKeyWidth),
                                  )),

                              const Dividerbottomsheetboardgamedetail(
                                  height: 24, color: mainGrey),

                              // 설명 섹션
                              _buildSectionTitle(AppString.explanation),
                              const SizedBox(height: 24),
                              Text(
                                widget.gameDescription,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: FontString.pretendardMedium,
                                  color: mainGrey,
                                ),
                              ),

                              const Dividerbottomsheetboardgamedetail(
                                  height: 24, color: mainGrey),

                              // 제작사/제작자 섹션
                              _buildSectionTitle(AppString.producer),
                              const SizedBox(height: 4),
                              ...gameMakerInfo.map((info) => Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: _buildSectionInfo(info['title'],
                                        info['value'], maxKeyWidth),
                                  )),

                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 닫기 버튼 (고정 영역)
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: mainGrey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryBlack,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: Text(
                      AppString.close,
                      style: TextStyle(
                        color: mainWhite,
                        fontSize: 16,
                        fontFamily: FontString.pretendardBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 섹션 타이틀 스타일
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 20,
          fontFamily: FontString.pretendardSemiBold,
          color: mainWhite),
    );
  }

  // 섹션 정보 스타일
  Widget _buildSectionInfo(String key, dynamic value, double maxKeyWidth) {
    if (value == null) return const SizedBox();

    // 값에 따라 분기.
    String displayValue;
    switch (value) {
      case int _ when key == '연령':
        displayValue = '$value세';
        break;

      case int _ when key == '최소 인원 수':
        displayValue = '$value인';
        break;

      case int _ when key == '최대 인원 수':
        displayValue = '$value인';
        break;

      case int _ when key == '평균 플레이 시간':
        if (value >= 60) {
          int hours = value ~/ 60;
          int minutes = value % 60;

          if (minutes == 0) {
            displayValue = '$hours시간';
          } else {
            displayValue = '$hours시간 $minutes분';
          }
        } else {
          displayValue = '$value분';
        }
        break;

      case int _ when key == AppString.difficulty:
        displayValue = switch (value) {
          0 => AppString.difficultyBeginnerValue,
          1 => AppString.difficultyIntermediateValue,
          2 => AppString.difficultyAdvancedValue,
          _ => AppString.difficultyUnKnownValue,
        };
        break;

      case List<String>():
        displayValue = value.join(' • ');
        break;

      default:
        displayValue = value.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // key 영역
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: maxKeyWidth),
            child: Text(
              key,
              style: TextStyle(
                fontSize: 16,
                fontFamily: FontString.pretendardMedium,
                color: mainWhite,
              ),
            ),
          ),

          const SizedBox(width: 20),

          // value 영역
          Flexible(
            child: Text(
              displayValue,
              style: TextStyle(
                fontSize: 16,
                fontFamily: FontString.pretendardMedium,
                color: mainGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
