import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamesboard/constants/AppData.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/feature/mission/screen/MissionDetailScreen.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/AppString.dart';
import '../../../widget/physics/CustomScrollPhysics.dart';
import '../viewmodel/MissionViewModel.dart';
import '../widget/ImageItemMissionList.dart';

class MissionListScreen extends StatefulWidget {
  final String title;

  const MissionListScreen({super.key, required this.title});

  @override
  State<MissionListScreen> createState() => _MissionListScreenState();
}

class _MissionListScreenState extends State<MissionListScreen> with RouteAware {
  DateTime? currentBackPressTime;

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    if (currentBackPressTime == null ||
        currentTime.difference(currentBackPressTime!) >
            const Duration(seconds: 2)) {
      currentBackPressTime = currentTime;
      Fluttertoast.showToast(
          msg: "'뒤로' 버튼을 한번 더 누르시면 종료됩니다.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xff6E6E6E),
          fontSize: 14,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    return true;

    SystemNavigator.pop();
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MissionViewModel>().getAllArchives();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    context.read<MissionViewModel>().getAllArchives();
  }

  @override
  Widget build(BuildContext context) {
    final archives =
        context.watch<MissionViewModel>().archives.reversed.toList();
    final isLoading = context.watch<MissionViewModel>().isLoading;

    if (isLoading) {
      return WillPopScope(
        onWillPop: onWillPop,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            itemCount: 30, // 로딩 중일 때는 더미 아이템 수
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: shimmerBaseColor,
                highlightColor: shimmerHighlightColor,
                child: Container(
                  color: mainWhite,
                ),
              );
            },
          ),
        ),
      );
    }

    if (archives.isEmpty) {
      return WillPopScope(
        onWillPop: onWillPop,
        child: Center(
          child: Text(
            '등록된 미션들이 없습니다.',
            style: TextStyle(
              color: mainWhite,
              fontSize: 18,
              fontFamily: FontString.pretendardSemiBold,
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: GridView.builder(
          physics: CustomScrollPhysics(scrollSpeedFactor: AppData.scrollSpeed),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
          ),
          itemCount: archives.length,
          itemBuilder: (context, index) {
            return ImageItemMissionList(
              imageUrl: archives[index].archiveImage,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MissionDetailScreen(
                      title: AppString.missionDetailTitle,
                      archiveId: archives[index].archiveId,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
