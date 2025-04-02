import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/feature/mission/viewmodel/MissionViewModel.dart';
import 'package:jamesboard/feature/mission/widget/HashTagMissionDetail.dart';
import 'package:jamesboard/feature/mission/widget/ProfileMissionDetail.dart';
import 'package:jamesboard/main.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    context.read<MissionViewModel>().getArchiveById(widget.archiveId);
    context.read<MissionViewModel>().loadLoginUserId();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MissionViewModel>();

    if (viewModel.isLoading) {
      return const Scaffold(
        backgroundColor: mainBlack,
        body: Center(
          child: CircularProgressIndicator(),
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
            '데이터를 불러오지 못했습니다.',
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
      body: Column(
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
                Navigator.of(context).pop(true);
              },
            ),
          ),

          const SizedBox(height: 12),

          // 사진 영역 (최대 9장까지 지원)
          AspectRatio(
            aspectRatio: 1, // 1:1 비율
            child: PageView.builder(
              controller: _pageController,
              itemCount: archiveDetailResponse.archiveImageList.length,
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: archiveDetailResponse.archiveImageList.length,
                effect: ScaleEffect(
                  activeDotColor: mainRed,
                  dotColor: mainGrey,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                  scale: 1.5,
                ),
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
                  '${archiveDetailResponse.userNickName} ${archiveDetailResponse.archiveContent}',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: FontString.pretendardMedium,
                    color: mainWhite,
                  ),
                ),

                const SizedBox(height: 12),

                // 해시태그
                Row(
                  children: [
                    HashTagMissionDetail(info: archiveDetailResponse.gameTitle),
                    const SizedBox(
                      width: 8,
                    ),
                    HashTagMissionDetail(
                        info: '${archiveDetailResponse.archiveGamePlayCount}판')
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
