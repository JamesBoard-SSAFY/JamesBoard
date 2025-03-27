import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/theme/Colors.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 두 개의 탭 설정
  }

  @override
  void dispose() {
    _tabController.dispose(); // 메모리 누수 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 16,
              ),
              CircleAvatar(
                radius: 35,
                backgroundImage:
                    AssetImage('assets/image/image_default_profile.png'),
                backgroundColor: mainBlack,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "장킨스",
                    style: TextStyle(
                      color: mainWhite,
                      fontSize: 20,
                      fontFamily: 'PretendardBold',
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: secondaryBlack,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: SvgPicture.asset(
                        'assets/image/icon_pen.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
          TabBar(
            controller: _tabController,
            labelColor: mainGold, // 선택된 탭 텍스트 색
            unselectedLabelColor: mainGrey, // 선택되지 않은 탭 텍스트 색
            indicatorColor: mainGold, // 인디케이터 색
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelStyle: TextStyle( // 선택된 탭 텍스트 스타일
              fontSize: 16,
              color: mainGold,
              fontFamily: 'PretendardBold',
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
              color: mainGrey,
              fontFamily: 'Pretendard',
            ),
            tabs: [
              Tab(text: "임무 보고"),
              Tab(text: "임무 통계"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent("탭 1 콘텐츠"), // 첫 번째 탭의 콘텐츠
                _buildTabContent("탭 2 콘텐츠"), // 두 번째 탭의 콘텐츠
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: mainWhite,
          fontSize: 18,
          fontFamily: 'PretendardBold',
        ),
      ),
    );
  }
}
