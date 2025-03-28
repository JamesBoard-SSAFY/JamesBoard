import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/feature/user/widget/item/ItemUserGenrePercentInfo.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../../../widget/image/ImageCommonMyPageGameCard.dart';
import '../widget/chart/ChartUserGenrePercent.dart';

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
            labelColor: mainGold,
            // 선택된 탭 텍스트 색
            unselectedLabelColor: mainGrey,
            // 선택되지 않은 탭 텍스트 색
            indicatorColor: mainGold,
            // 인디케이터 색
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelStyle: TextStyle(
              // 선택된 탭 텍스트 스타일
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
                _buildTabContent1(),
                _buildTabContent2(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 임무 보고
  Widget _buildTabContent1() {
    var images = [
      {
        'id': '1',
        'img':
            'https://cf.geekdo-images.com/rpwCZAjYLD940NWwP3SRoA__thumb/img/YT6svCVsWqLrDitcMEtyazVktbQ=/fit-in/200x150/filters:strip_icc()/pic4718279.jpg'
      },
      {
        'id': '2',
        'img':
            'https://cf.geekdo-images.com/o9-sNXmFS_TLAb7ZlZ4dRA__thumb/img/22MSUC0-ZWgwzhi_VKIbENJik1w=/fit-in/200x150/filters:strip_icc()/pic3211873.jpg'
      },
      {
        'id': '3',
        'img':
            'https://cf.geekdo-images.com/FfguJeknahk88vKT7C3JLA__thumb/img/cpf23VxElZxuYaIGcgrjPn80sZY=/fit-in/200x150/filters:strip_icc()/pic7376875.jpg'
      },
      {
        'id': '4',
        'img':
            'https://cf.geekdo-images.com/8SADtu_4zBH_UJrCo935Iw__thumb/img/vwTEQOWA3Mw__ztkTMulOgJ82Pw=/fit-in/200x150/filters:strip_icc()/pic6348964.jpg'
      },
      {
        'id': '5',
        'img':
            'https://cf.geekdo-images.com/k7lG683LBZdvFyS-FH-MpA__thumb/img/6KTtiknxxGwd0ARKrlsdoXFtHfI=/fit-in/200x150/filters:strip_icc()/pic6746812.png'
      },
      {
        'id': '6',
        'img':
            'https://cf.geekdo-images.com/PyUol9QxBnZQCJqZI6bmSA__thumb/img/virV2Bm82Dql7gh-LZScBwqByik=/fit-in/200x150/filters:strip_icc()/pic8632666.png'
      },
      {
        'id': '7',
        'img':
            'https://cf.geekdo-images.com/eJx8hRJ6-86C2VrhECwEPA__thumb/img/J1PlqFqtN-hxuXM4eEi-ekANPP4=/fit-in/200x150/filters:strip_icc()/pic1000553.jpg'
      },
      {
        'id': '8',
        'img':
            'https://cf.geekdo-images.com/nMitZr9Lu4Ux7LLqBy7Z8A__thumb/img/mLHWOFfdxrWljImkFZ2ulIhHt7A=/fit-in/200x150/filters:strip_icc()/pic6875169.png'
      },
      {
        'id': '9',
        'img':
            'https://cf.geekdo-images.com/soAzNVWglCdVBacNjoCTJw__thumb/img/0UPEyOaSFyqEH1ikrSig_218RQ0=/fit-in/200x150/filters:strip_icc()/pic2338267.jpg'
      },
      {
        'id': '10',
        'img':
            'https://cf.geekdo-images.com/wX4cTWNjTG7XiGHGgSpiiw__thumb/img/vU6kaL3f06BaVfmwUV91trrvDng=/fit-in/200x150/filters:strip_icc()/pic8630033.png'
      },
      {
        'id': '11',
        'img':
            'https://cf.geekdo-images.com/iif2Nv17Vhw8puN2bATaaw__thumb/img/GtXKwk8tJkmHtUvWPT2FIabXh0w=/fit-in/200x150/filters:strip_icc()/pic7794273.png'
      },
      {
        'id': '12',
        'img':
            'https://cf.geekdo-images.com/o23NBqu_LBRAtRaVoOBBhQ__thumb/img/VEXGKhNHkULY2hJ41r4Agob5RvE=/fit-in/200x150/filters:strip_icc()/pic403442.jpg'
      },
      {
        'id': '13',
        'img':
            'https://cf.geekdo-images.com/AL5D-dXabY-Lk3PqIFk_0g__thumb/img/Q-76aN92M3OveMp26t7b0i7V-i4=/fit-in/200x150/filters:strip_icc()/pic4597095.jpg'
      },
      {
        'id': '14',
        'img':
            'https://cf.geekdo-images.com/3qg1xTP7ZZiu8OolGBYJ1w__thumb/img/2LGbUy0Hen-8-8bQ-ZfwHjNnCtU=/fit-in/200x150/filters:strip_icc()/pic1766273.jpg'
      },
      {
        'id': '15',
        'img':
            'https://cf.geekdo-images.com/ajU3xzGDUKihjNdvjCR1Hw__thumb/img/pXR57sUMEJ-GJydf-yyAu0ZLgZw=/fit-in/200x150/filters:strip_icc()/pic3328391.jpg'
      },
    ];

    void handleImageTap(String id) {
      print('클릭한 이미지 ID: $id');
      // 여기에 원하는 동작 추가
    }

    return Expanded(
      child: ImageCommonMyPageGameCard(
        images: images,
        onTap: handleImageTap,
      ),
    );
  }

  // 임무 통계
  Widget _buildTabContent2() {
    var genres = [
      {'genre': '전략', 'percent': 25, 'color': Colors.blue},
      {'genre': '파티', 'percent': 22, 'color': Colors.red},
      {'genre': '추리', 'percent': 19, 'color': Colors.green},
      {'genre': '경제', 'percent': 17.5, 'color': Colors.orange},
      {'genre': '모험', 'percent': 16.5, 'color': Colors.purple},
    ];

    List<ChartData> chartData = genres.map((genre) {
      return ChartData(
        genre['genre'] as String,
        (genre['percent'] as num).toDouble(),
        genre['color'] as Color,
      );
    }).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "임무 유형별 통계",
                  style: TextStyle(
                    fontSize: 24,
                    color: mainWhite,
                    fontFamily: 'PretendardBold',
                  ),
                ),
              ],
            ),
            ChartUserGenrePercent(chartData: chartData),
            ItemUserGenrePercentInfo(genres: genres,),
          ],
        ),
      ),
    );
  }
}
