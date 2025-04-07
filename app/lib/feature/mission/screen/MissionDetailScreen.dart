import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/feature/mission/screen/MissionListScreen.dart';
import 'package:jamesboard/feature/mission/viewmodel/MissionViewModel.dart';
import 'package:jamesboard/feature/mission/widget/HashTagMissionDetail.dart';
import 'package:jamesboard/feature/mission/widget/ProfileMissionDetail.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../widget/appbar/DefaultCommonAppBar.dart';

class MissionDetailScreen extends StatefulWidget {
  final String title;
  final int archiveId;

  const MissionDetailScreen({
    super.key,
    required this.title,
    required this.archiveId,
  });

  @override
  State<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends State<MissionDetailScreen> {
  final PageController _pageController = PageController();

  Future<void> _initDetailData() async {
    final vm = context.read<MissionViewModel>();

    await vm.loadLoginUserId(); // loginUserId 먼저 로딩
    await vm.getArchiveById(widget.archiveId); // 그 다음 아카이브 상세
  }

  @override
  void initState() {
    super.initState();
    _initDetailData();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MissionViewModel>();

    if (viewModel.isLoading) {
      return Scaffold(
        backgroundColor: mainBlack,
        appBar: DefaultCommonAppBar(
          title: widget.title,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Shimmer.fromColors(
              baseColor: shimmerBaseColor,
              highlightColor: shimmerHighlightColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 프로필 영역
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: mainWhite,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 100,
                        height: 16,
                        color: mainWhite,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 이미지 영역
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: mainWhite,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 인디케이터 대체 (작은 박스)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: mainWhite,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  // 게시글 설명 영역
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: mainWhite,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: mainWhite,
                  ),
                  const SizedBox(height: 12),

                  // 해시태그 영역
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 24,
                        color: mainWhite,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 24,
                        color: mainWhite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (viewModel.hasError ||
        viewModel.archiveDetailResponse == null ||
        viewModel.loginUserId == null) {
      return const Scaffold(
        backgroundColor: mainBlack,
        body: Center(
          child: Text(
            AppString.notLoadedData,
            style: TextStyle(
              color: mainWhite,
            ),
          ),
        ),
      );
    }

    final archiveDetailResponse = viewModel.archiveDetailResponse!;

    return Scaffold(
      backgroundColor: mainBlack,
      appBar: DefaultCommonAppBar(
        title: widget.title,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ProfileMissionDetail(
                imageUrl: archiveDetailResponse.userProfile,
                userName: archiveDetailResponse.userNickName,
                archiveUserId: archiveDetailResponse.userId,
                loginUserId: viewModel.loginUserId!,
                archiveId: widget.archiveId,
                onDeleteSuccess: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const MyHome(
                        title: 'Flutter Demo Home Page',
                        selectedIndex: 3,
                      ),
                    ),
                    (route) => false, // 모든 이전 스택 제거
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // 사진 영역 (최대 9장까지 지원)
            AspectRatio(
              aspectRatio: 1, // 1:1 비율
              child: PageView.builder(
                controller: _pageController,
                itemCount: archiveDetailResponse.archiveImageList.length ?? 0,
                itemBuilder: (context, index) {
                  return Image.network(
                    archiveDetailResponse
                        .archiveImageList[index], // 또는 Image.network 가능
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // 인디케이터
            if (archiveDetailResponse.archiveImageList.length > 1)
              SmoothPageIndicator(
                controller: _pageController,
                count: archiveDetailResponse.archiveImageList.length,
                effect: ScaleEffect(
                  activeDotColor: mainRed,
                  dotColor: mainGrey,
                  dotHeight: 6,
                  dotWidth: 6,
                  spacing: 6,
                  scale: 1.5,
                ),
              ),

            // 게시물 설명
            Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 16.0, bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    archiveDetailResponse.archiveContent,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontString.pretendardMedium,
                      color: mainWhite,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 해시태그
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      HashTagMissionDetail(
                          info: archiveDetailResponse.gameTitle),
                      HashTagMissionDetail(
                          info:
                              '${archiveDetailResponse.archiveGamePlayCount}판')
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
