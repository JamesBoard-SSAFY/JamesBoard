import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/feature/mission/screen/MissionDetailScreen.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/AppString.dart';
import '../viewmodel/MissionViewModel.dart';
import '../widget/ImageItemMissionList.dart';

class MissionListScreen extends StatefulWidget {
  final String title;

  const MissionListScreen({super.key, required this.title});

  @override
  State<MissionListScreen> createState() => _MissionListScreenState();
}

class _MissionListScreenState extends State<MissionListScreen> with RouteAware {
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

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: isLoading
          ? GridView.builder(
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
            )
          : GridView.builder(
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
    );
  }
}
