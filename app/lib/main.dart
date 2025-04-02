import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/feature/boardgame/screen/BoardGameHomeScreen.dart';
import 'package:jamesboard/feature/boardgame/viewmodel/BoardGameViewModel.dart';
import 'package:jamesboard/feature/boardgame/viewmodel/CategoryGameViewModel.dart';
import 'package:jamesboard/feature/mission/screen/MissionEditScreen.dart';
import 'package:jamesboard/feature/mission/screen/MissionListScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jamesboard/feature/login/screen/LoginScreen.dart';
import 'package:jamesboard/repository/ArchiveRepository.dart';
import 'package:jamesboard/repository/LoginRepository.dart';
import 'package:jamesboard/repository/SurveyRepository.dart';
import 'package:jamesboard/repository/BoardGameRepository.dart';
import 'package:jamesboard/repository/LoginRepository.dart';
import 'package:jamesboard/repository/MyPageRepository.dart';
import 'package:jamesboard/repository/S3Repository.dart';
import 'package:jamesboard/util/AppBarUtil.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:logger/logger.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:provider/provider.dart';
import 'feature/mission/viewmodel/MissionViewModel.dart';
import 'feature/survey/viewmodel/SurveyViewModel.dart';
import 'feature/user/screen/MyPageScreen.dart';
import 'feature/boardgame/screen/RecommendGameScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import 'feature/user/viewmodel/MyPageViewModel.dart';

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

  final loginRepository = LoginRepository.create();
  final myPageRepository = MyPageRepository.create();
  final s3Repository = S3Repository.create();
  final myPageViewModel =
      MyPageViewModel(myPageRepository, loginRepository, s3Repository, storage);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SurveyViewModel>(
          create: (context) => SurveyViewModel(
            SurveyRepository.create(),
            LoginRepository.create(),
          ),
        ),
        ChangeNotifierProvider<CategoryGameViewModel>(
          create: (context) => CategoryGameViewModel(
            BoardGameRepository.create(),
          ),
        ),
        ChangeNotifierProvider<BoardGameViewModel>(
          create: (context) => BoardGameViewModel(
            BoardGameRepository.create(),
          ),
        ),
        ChangeNotifierProvider<MissionViewModel>(
          create: (context) => MissionViewModel(
            ArchiveRepository.create(),
            LoginRepository.create(),
          ),
        ),
        ChangeNotifierProvider<MyPageViewModel>(
          create: (context) => MyPageViewModel(
            MyPageRepository.create(),
            LoginRepository.create(),
            S3Repository.create(),
            storage,
          ),
        )
      ],
      child: MyApp(isLoggedIn: false),
    ),
  );
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
    RecommendGameScreen(),
    MissionEditScreen(title: AppString.missionEditTitle),
    MissionListScreen(title: AppString.missionListTitle),
    MyPageScreen(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MissionEditScreen(title: AppString.missionEditTitle)),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });

      // 아카이브 탭이면 최신 아카이브 데이터 받아오기.
      if (index == 3) {
        context.read<MissionViewModel>().getAllArchives();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarUtil.getAppBar(_selectedIndex),
      body: _pages[_selectedIndex],
      backgroundColor: mainBlack,
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
              icon: SvgPicture.asset(IconPath.homeUnselected,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
              activeIcon: SvgPicture.asset(IconPath.homeSelected,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
              label: AppString.labelHome),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(IconPath.recommendUnselected,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
            activeIcon: SvgPicture.asset(IconPath.recommendSelected,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
            label: AppString.labelRecommend,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(IconPath.registerUnselected,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
            label: AppString.labelSearch,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(IconPath.archiveUnselected,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
            activeIcon: SvgPicture.asset(IconPath.archiveSelected,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
            label: AppString.labelArchive,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(IconPath.myPageUnselected,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
            activeIcon: SvgPicture.asset(IconPath.myPageSelected,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(mainWhite, BlendMode.srcIn)),
            label: AppString.labelMyPage,
          ),
        ],
      ),
    );
  }
}
