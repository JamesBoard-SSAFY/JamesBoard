import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/dummy/AppDummyData.dart';
import '../../../constants/FontString.dart';
import '../../../widget/bottomsheet/BottomSheetCommonFilter.dart';
import '../widget/image/ImageMissionGameInformation.dart';
import '../widget/item/ItemUserArchiveCard.dart';

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
  int selectedIndex = 0; // 선택된 월 버튼 (초기값: '전체')
  String selectedText = '전체'; // 선택된 버튼 텍스트
  String selectedYear = "2025년"; // 기본 연도

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlack,
      body: SafeArea(
        child: SingleChildScrollView(
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
                        Navigator.pop(context); // 뒤로 가기
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
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  color: mainGrey,
                  width: double.infinity,
                  height: 1,
                ),
              ),
              SizedBox(height: 20),

              // 연도 선택 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () async {
                    // 바텀 시트 호출
                    String? result = await showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return BottomSheetCommonFilter(
                          items: List.generate(10, (index) => "${2025 - index}년"),
                          initialValue: selectedYear,
                        );
                      },
                    );

                    if (result != null) {
                      setState(() {
                        selectedYear = result;
                        selectedIndex = 0; // 연도 변경 시 '전체' 선택
                        selectedText = '전체';
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        selectedYear,
                        style: TextStyle(
                          fontSize: 20,
                          color: mainWhite,
                          fontFamily: FontString.pretendardSemiBold,
                        ),
                      ),
                      SizedBox(width: 4),
                      SvgPicture.asset('assets/image/icon_arrow_down.svg'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 월 선택 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(13, (index) {
                      String text = index == 0 ? '전체' : '${index}월';
                      bool isSelected = selectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              selectedIndex = index;
                              selectedText = text;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(mainBlack),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(
                                  color: isSelected ? mainGold : mainGrey,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          child: Text(
                            text,
                            style: TextStyle(
                              color: isSelected ? mainGold : mainGrey,
                              fontSize: 16,
                              fontFamily: FontString.pretendardSemiBold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // ✅ 선택한 월 출력
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      selectedText,
                      style: TextStyle(
                          fontSize: 24,
                          color: mainWhite,
                          fontFamily: FontString.pretendardSemiBold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 8, 20),
                child: ItemUserArchiveCard(
                  missionData: AppDummyData.missionData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
