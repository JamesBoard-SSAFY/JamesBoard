import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jamesboard/feature/boardgame/screen/AddArchieveScreenEx.dart';
import 'package:jamesboard/feature/boardgame/screen/BoardGameHomeScreen.dart';
import 'package:jamesboard/feature/boardgame/screen/ListArchieveScreenEx.dart';
import 'package:jamesboard/feature/boardgame/screen/MyPageScreenEx.dart';
import 'package:jamesboard/feature/boardgame/screen/RecommGameScreenEx.dart';
import 'package:jamesboard/feature/login/screen/LoginScreen.dart';
import 'package:jamesboard/feature/mission/screen/MissionEditScreen.dart';
import 'package:jamesboard/util/AppBarUtil.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:logger/logger.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

final logger = Logger(
    printer: PrettyPrinter(
  colors: true,
  printEmojis: true,
  printTime: true,
));

final storage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(nativeAppKey: 'd6a47244edea272d361af14d6d35d274');

  final keyHash = await KakaoSdk.origin;
  logger.d('현재 사용 중인 키 해시 : $keyHash');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');

  final isLoggedIn = accessToken != null && accessToken.isNotEmpty;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'JamesBoard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        splashColor: Colors.transparent, // 클릭 시 원형 퍼지는 효과 제거
      ),
      home: isLoggedIn
          ? const MyHomePage(title: 'Flutter Demo Home Page')
          : const LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> items = List.generate(20, (index) => 'Item $index');
  final List<Widget> _pages = [
    BoardGameHomeScreen(),
    RecommGameScreenEx(),
    MissionEditScreen(title: '임무 보고'),
    ListArchieveScreenEx(),
    MyPageScreenEx()
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MissionEditScreen(title: '임무 보고')), // 현재 화면을 새로운 화면으로 대체
      ).then((_) {
        setState(() {
          _selectedIndex = 0; // Home 화면으로 돌아가기
        });
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarUtil.getAppBar(_selectedIndex),
      body: _pages[_selectedIndex],
      backgroundColor: mainBlack, // 배경색 검정으로 설정
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: mainBlack,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: mainWhite,
          unselectedItemColor: mainWhite,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/image/icon_home_unselected.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
              activeIcon: SvgPicture.asset(
                  'assets/image/icon_home_selected.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                  'assets/image/icon_recommend_unselected.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
              activeIcon: SvgPicture.asset(
                  'assets/image/icon_recommend_selected.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
              label: 'recommend',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                  'assets/image/icon_register_unselected.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
              label: 'search',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/image/icon_archive_unselected.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
              activeIcon: SvgPicture.asset(
                  'assets/image/icon_archive_selected.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
              label: 'recommend',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/image/icon_mypage_unselected.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
              activeIcon: SvgPicture.asset(
                  'assets/image/icon_mypage_selected.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
              label: 'mypage',
            ),
          ]),
    );
  }
}
