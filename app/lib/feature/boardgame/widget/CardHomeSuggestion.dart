import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/feature/boardgame/viewmodel/BoardGameViewModel.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/FontString.dart';

class CardHomeSuggestion extends StatefulWidget {
  final List<Map<String, String>> images;
  final Function(int id) onImageTap;

  const CardHomeSuggestion({
    super.key,
    required this.images,
    required this.onImageTap,
  });

  @override
  _CardHomeSuggestionState createState() => _CardHomeSuggestionState();
}

class _CardHomeSuggestionState extends State<CardHomeSuggestion> {
  late PageController _pageController;
  late int _currentPage;
  late BoardGameViewModel boardGameViewModel;
  Timer? _autoScrollTimer;
  Timer? _userInteractionTimer;
  double? _lastPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 90000);
    _currentPage = 0;
    boardGameViewModel = Provider.of<BoardGameViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      boardGameViewModel.getRecommendedGames();
      _startAutoScroll();
      _startUserScrollWatcher();
    });
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(Duration(seconds: 3), (_) {
      if (_pageController.hasClients && boardGameViewModel.recommendedGames.isNotEmpty) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  void _startUserScrollWatcher() {
    _userInteractionTimer = Timer.periodic(Duration(milliseconds: 300), (_) {
      if (_pageController.hasClients) {
        double? currentPage = _pageController.page;
        if (_lastPage != null && currentPage == _lastPage) {
          // 스크롤이 멈춤
          if (_autoScrollTimer == null || !_autoScrollTimer!.isActive) {
            _startAutoScroll();
          }
        } else {
          // 스크롤 중
          _stopAutoScroll();
        }
        _lastPage = currentPage;
      }
    });
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _userInteractionTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardGameViewModel>(
      builder: (context, viewModel, child) {
        final isLoading = viewModel.isLoading;

        return Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              double height = width * 1.1;

              return SizedBox(
                height: height,
                child: isLoading
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Shimmer.fromColors(
                    baseColor: shimmerBaseColor,
                    highlightColor: shimmerHighlightColor,
                    child: Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                )
                    : Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: null, // 무한 스크롤 느낌
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index % viewModel.recommendedGames.length;
                        });
                      },
                      itemBuilder: (context, index) {
                        if (viewModel.recommendedGames.isEmpty) return Container();
                        final game = viewModel.recommendedGames[index % viewModel.recommendedGames.length];
                        final imageUrl = game.gameImage;
                        final id = game.gameId;

                        return GestureDetector(
                          onTap: () {
                            _stopAutoScroll();
                            widget.onImageTap(id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
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
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                                text: ' / ${viewModel.recommendedGames.length}',
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
    );
  }
}
