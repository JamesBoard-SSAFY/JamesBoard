import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

class CardHomeSuggestion extends StatefulWidget {
  final List<Map<String, String>> images; // {id: imageUrl}
  final Function(String id) onImageTap; // 클릭 시 수행할 작업

  const CardHomeSuggestion({super.key, required this.images, required this.onImageTap});

  @override
  _CardHomeSuggestionState createState() => _CardHomeSuggestionState();
}

class _CardHomeSuggestionState extends State<CardHomeSuggestion> {
  late PageController _pageController;
  late int _currentPage;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _currentPage = 0;
    _startAutoScroll();
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
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = width * 1.1;

        return SizedBox(
          height: height,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: null, // 무한 스크롤 효과
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index % widget.images.length;
                  });
                },
                itemBuilder: (context, index) {
                  final image = widget.images[index % widget.images.length];
                  final imageUrl = image['url']!;
                  final id = image['id']!;

                  return GestureDetector(
                    onTap: () => widget.onImageTap(id),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
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
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                            fontFamily: 'PretendardBold',
                          ),
                        ),
                        TextSpan(
                          text: ' / ${widget.images.length}',
                          style: TextStyle(
                            color: mainWhite,
                            fontSize: 16,
                            fontFamily: 'PretendardBold',
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
    );
  }
}