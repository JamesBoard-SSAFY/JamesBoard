import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jamesboard/feature/boardgame/viewmodel/BoardGameViewModel.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/FontString.dart';
import '../../../repository/BoardGameRepository.dart';

class CardHomeSuggestion extends StatefulWidget {
  final List<Map<String, String>> images;
  final Function(int id) onImageTap;

  const CardHomeSuggestion(
      {super.key, required this.images, required this.onImageTap});

  @override
  _CardHomeSuggestionState createState() => _CardHomeSuggestionState();
}

class _CardHomeSuggestionState extends State<CardHomeSuggestion> {
  late PageController _pageController;
  late int _currentPage;
  late BoardGameViewModel boardGameViewModel;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _currentPage = 0;
    _startAutoScroll();

    boardGameViewModel =
        Provider.of<BoardGameViewModel>(context, listen: false);
    boardGameViewModel.getRecommendedGames();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 타이머 정리
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardGameViewModel(BoardGameRepository.create())
        ..getRecommendedGames(limit: 10),
      child: Consumer<BoardGameViewModel>(
        builder: (context, viewModel, child) {
          final isLoading = viewModel.isLoading;
          final recommendedGames = viewModel.recommendedGames;

          return Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double width = constraints.maxWidth;
                double height = width * 1.1;

                return SizedBox(
                  height: height, // 높이 유지
                  child: isLoading
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: width,
                              height: height,
                              decoration: BoxDecoration(
                                color: Colors.grey[400], // 기본 배경 색상
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                          ),
                        )
                      : Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: null, // 무한 스크롤 효과
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage =
                                      index % viewModel.recommendedGames.length;
                                });
                              },
                              itemBuilder: (context, index) {
                                final game = viewModel.recommendedGames[
                                    index % viewModel.recommendedGames.length];
                                final imageUrl = game.gameImage;
                                final id = game.gameId;

                                return GestureDetector(
                                  onTap: () {
                                    _timer?.cancel();
                                    widget.onImageTap(id);
                                    _startAutoScroll();
                                  },
                                  onTapDown: (_) {
                                    _timer?.cancel();
                                  },
                                  onTapUp: (_) {
                                    _startAutoScroll();
                                  },
                                  onTapCancel: () {
                                    _startAutoScroll();
                                  },
                                  onLongPress: () {
                                    _timer?.cancel();
                                  },
                                  onLongPressUp: () {
                                    _startAutoScroll();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4.0),
                                      child: Image.network(
                                        imageUrl,
                                        width: width,
                                        height: height,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 5,
                              right: 40,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${_currentPage + 1}',
                                        style: TextStyle(
                                          color: mainGold,
                                          fontSize: 16,
                                          fontFamily: FontString.pretendardBold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ' / ${viewModel.recommendedGames.length}',
                                        style: TextStyle(
                                          color: mainWhite,
                                          fontSize: 16,
                                          fontFamily: FontString.pretendardBold,
                                        ),
                                      ),
                                    ],
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
        },
      ),
    );
  }
}
