import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/feature/mission/widget/HashTagMissionDetail.dart';
import 'package:jamesboard/feature/mission/widget/ProfileMissionDetail.dart';
import 'package:jamesboard/theme/Colors.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../widget/appbar/DefaultCommonAppBar.dart';

class MissionDetailScreen extends StatefulWidget {
  final String title;
  final String profileImageUrl;
  final String userName;
  final List<String> missionImageUrls;
  final String missionDescription;
  final String gameName;
  final int playCount;
  final int gamePlayTime;

  const MissionDetailScreen({
    super.key,
    required this.title,
    required this.missionImageUrls,
    required this.userName,
    required this.profileImageUrl,
    required this.missionDescription,
    required this.gameName,
    required this.playCount,
    required this.gamePlayTime,
  });

  @override
  State<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends State<MissionDetailScreen> {
  final PageController _pageController = PageController();

  String _getFormattedPlayTime(int averagePlayTime, int playCount) {
    int totalMinutes = averagePlayTime * playCount;
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    if (hours > 0) {
      if (minutes > 0) {
        return '$hours시간 $minutes분';
      } else {
        return '$hours시간';
      }
    } else {
      return '$minutes분';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                imageUrl: widget.profileImageUrl, userName: widget.userName),
          ),

          const SizedBox(height: 12),

          // 사진 영역 (최대 9장까지 지원)
          AspectRatio(
            aspectRatio: 1, // 1:1 비율
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.missionImageUrls.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  widget.missionImageUrls[index], // 또는 Image.network 가능
                  fit: BoxFit.cover,
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // 인디케이터
          if (widget.missionImageUrls.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: widget.missionImageUrls.length,
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
                  '${widget.userName} ${widget.missionDescription}',
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
                    HashTagMissionDetail(info: widget.gameName),
                    const SizedBox(
                      width: 8,
                    ),
                    HashTagMissionDetail(
                      info: _getFormattedPlayTime(
                          widget.gamePlayTime, widget.playCount),
                    )
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
