import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/util/dummy/AppDummyData.dart';
import '../../../constants/FontString.dart';
import '../../../util/CommonUtils.dart';
import '../../../widget/bottomsheet/BottomSheetCommonFilter.dart';
import '../widget/image/ImageMissionGameInformation.dart';
import '../widget/item/ItemUserArchiveCard.dart';

class MissionRecordScreen extends StatefulWidget {
  final int id;

  const MissionRecordScreen({super.key, required this.id});

  @override
  State<MissionRecordScreen> createState() => _MissionRecordScreenState();
}

class _MissionRecordScreenState extends State<MissionRecordScreen> {
  var dummyData = AppDummyData.missionReportGameData;
  int selectedIndex = 0; // '전체' 선택
  String selectedText = '전체'; // 선택된 버튼 텍스트
  late String selectedYear; // 선택된 연도
  late List<String> availableYears; // 선택 가능한 연도 목록
  late List<String> availableMonths; // 선택 가능한 월 목록
  late List<Map<String, dynamic>> filteredArchiveList; // 필터링된 리스트

  @override
  void initState() {
    super.initState();

    availableYears =
        CommonUtils.extractAvailableYears(dummyData["archiveList"]);
    selectedYear = availableYears.isNotEmpty ? availableYears.first : "2025년";
    availableMonths = CommonUtils.extractAvailableMonths(
        dummyData["archiveList"], selectedYear);
    filteredArchiveList = CommonUtils.filterArchiveList(
        dummyData["archiveList"], selectedYear, selectedText);
  }

  void updateYear(String newYear) {
    setState(() {
      selectedYear = newYear;
      selectedIndex = 0;
      selectedText = '전체';
      availableMonths = CommonUtils.extractAvailableMonths(
          dummyData["archiveList"], selectedYear);
      filteredArchiveList = CommonUtils.filterArchiveList(
          dummyData["archiveList"], selectedYear, selectedText);
    });
  }

  void updateMonth(int index) {
    setState(() {
      selectedIndex = index;
      selectedText = index == 0 ? '전체' : "${index}월"; // 0은 '전체', 나머지는 1~12월
      filteredArchiveList = CommonUtils.filterArchiveList(
          dummyData["archiveList"], selectedYear, selectedText);
    });
  }

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
                      // 게임 정보 출력
                      ImageMissionGameInformation(gameData: dummyData),
                    ],
                  ),
                  Positioned(
                    top: 15,
                    left: 20,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
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
                              height: 12),
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
                    color: mainGrey, width: double.infinity, height: 1),
              ),
              SizedBox(height: 20),

              // 연도 선택
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () async {
                    String? result = await showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return BottomSheetCommonFilter(
                            items: availableYears, initialValue: selectedYear);
                      },
                    );
                    if (result != null) updateYear(result);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(selectedYear,
                          style: TextStyle(
                              fontSize: 20,
                              color: mainWhite,
                              fontFamily: FontString.pretendardSemiBold)),
                      SizedBox(width: 4),
                      SvgPicture.asset('assets/image/icon_arrow_down.svg'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 달 선택
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(13, (index) {
                      // 0번째는 '전체', 1~12번째는 1월~12월
                      String text = index == 0 ? "전체" : "$index월";
                      bool isSelected = selectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextButton(
                          onPressed: () => updateMonth(index),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(mainBlack),
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

              // 필터링된 정보 표시
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 8, 20),
                child: filteredArchiveList.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '등록된 임무 보고가 없습니다.',
                            style: TextStyle(
                              fontSize: 18,
                              color: mainWhite,
                              fontFamily: FontString.pretendardSemiBold,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          ItemUserArchiveCard(
                              missionDataList: filteredArchiveList),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
