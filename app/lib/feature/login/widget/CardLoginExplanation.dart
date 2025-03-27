import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CardLoginExplanation extends StatefulWidget {
  const CardLoginExplanation({super.key});

  @override
  _CardLoginExplanationState createState() => _CardLoginExplanationState();
}

class _CardLoginExplanationState extends State<CardLoginExplanation> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  final List<String> images = [
    "assets/image/login_pageview_dice.png",
    "assets/image/login_pageview_card.png",
    "assets/image/login_pageview_hourglass.png"
  ];

  final List<List<TextSpan>> text1List = [
    [
      TextSpan(
          text: "좋습니다 007,\n이번엔 ",
          style: TextStyle(
              fontSize: 32, color: mainWhite, fontFamily: 'PretendardBold')),
      TextSpan(
          text: "특별한 보드게임",
          style: TextStyle(
              fontSize: 32, color: mainGold, fontFamily: 'PretendardBold')),
      TextSpan(
          text: "이\n필요합니다.",
          style: TextStyle(
              fontSize: 32, color: mainWhite, fontFamily: 'PretendardBold')),
    ],
    [
      TextSpan(
          text: "먼저,\n당신의",
          style: TextStyle(
              fontSize: 32, color: mainWhite, fontFamily: 'PretendardBold')),
      TextSpan(
          text: "취향 ",
          style: TextStyle(
              fontSize: 32, color: mainGold, fontFamily: 'PretendardBold')),
      TextSpan(
          text: "을\n선택해 주셔야겠군요.",
          style: TextStyle(
              fontSize: 32, color: mainWhite, fontFamily: 'PretendardBold')),
    ],
    [
      TextSpan(
          text: "이제 제가 선정한\n게임 목록에서",
          style: TextStyle(
              fontSize: 32, color: mainWhite, fontFamily: 'PretendardBold')),
      TextSpan(
          text: "원하는 게임 ",
          style: TextStyle(
              fontSize: 32, color: mainGold, fontFamily: 'PretendardBold')),
      TextSpan(
          text: "을\n고르시면 됩니다.",
          style: TextStyle(
              fontSize: 32, color: mainWhite, fontFamily: 'PretendardBold')),
    ],
  ];

  final List<String> text2List = [
    "걱정 마세요, \n게임 추천은 제 전문이니까요.",
    "작전이 성공하려면 \n정확한 정보가 필수니까요.",
    "행운을 빕니다, 007. \n즐거운 임무 되시길."
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
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
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        return SizedBox(
          width: width,
          height: double.infinity,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: images.length * 10000, // 무한 스크롤
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index % images.length;
                  });
                },
                itemBuilder: (context, index) {
                  int actualIndex = index % images.length;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬 유지
                    children: [
                      RichText(
                        text: TextSpan(children: text1List[actualIndex]),
                      ),
                      SizedBox(height: 32),
                      Text(
                        text2List[actualIndex],
                        style: TextStyle(
                          fontSize: 16,
                          color: mainWhite,
                          fontFamily: 'PretendardBold',
                          height: 1.2,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        // 가능한 최대 공간 사용
                        child: Image.asset(
                          images[actualIndex],
                          width: width,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  );
                },
              ),
              // 페이지 인디케이터 추가
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: images.length,
                    effect: WormEffect(
                      dotWidth: 8.0,
                      dotHeight: 8.0,
                      spacing: 16.0,
                      dotColor: mainGrey,
                      activeDotColor: mainRed,
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
