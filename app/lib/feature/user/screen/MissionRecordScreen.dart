import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 사용을 위해 추가
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/dummy/AppDummyData.dart';

import '../../../constants/FontString.dart';
import '../../../widget/button/ButtonCommonGameTag.dart';
import '../widget/image/ImageMissionGameInformation.dart';

class MissionRecordScreen extends StatefulWidget {
  final int id;

  const MissionRecordScreen({
    super.key,
    required this.id,
  });

  @override
  State<MissionRecordScreen> createState() => _MissionRecordScreenState();
}

class _MissionRecordScreenState extends State<MissionRecordScreen> {
  int selectedIndex = 0; // 선택된 버튼의 인덱스 (초기값: '전체' 버튼)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    ImageMissionGameInformation(
                      gameData: AppDummyData.missionReportGameData,
                    ),
                  ],
                ),
                Positioned(
                  top: 15,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // 뒤로 가기 기능
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondaryBlack,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/image/icon_arrow_left.svg',
                          width: 12,
                          height: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
