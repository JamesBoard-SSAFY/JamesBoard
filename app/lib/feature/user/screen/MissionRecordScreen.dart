import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:provider/provider.dart';
import '../../../constants/FontString.dart';
import '../../../datasource/model/response/MyPage/MyPageArchiveResponse.dart';
import '../../../datasource/model/response/MyPage/MyPageMissionRecordResponse.dart';
import '../../../util/CommonUtils.dart';
import '../../../widget/bottomsheet/BottomSheetCommonFilter.dart';
import '../viewmodel/MyPageViewModel.dart';
import '../widget/image/ImageMissionGameInformation.dart';
import '../widget/item/ItemUserArchiveCard.dart';

class MissionRecordScreen extends StatefulWidget {
  final int id;

  const MissionRecordScreen({super.key, required this.id});

  @override
  State<MissionRecordScreen> createState() => _MissionRecordScreenState();
}

class _MissionRecordScreenState extends State<MissionRecordScreen> {
  late final MyPageViewModel viewModel;

  MyPageMissionRecordResponse missionRecord = MyPageMissionRecordResponse(
    gameTitle: '',
    gameImage: '',
    gameCategoryList: [],
    minAge: 0,
    gameYear: 0,
    minPlayer: 0,
    maxPlayer: 0,
    difficulty: 0,
    playTime: 0,
    archiveList: [],
  );
  late int selectedIndex; // '전체' 선택
  late String selectedText; // 선택된 버튼 텍스트
  late String selectedYear; // 선택된 연도
  late List<String> availableYears; // 선택 가능한 연도 목록
  late List<String> availableMonths; // 선택 가능한 월 목록
  late List<MyPageArchiveResponse> filteredArchiveList; // 필터링된 리스트

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<MyPageViewModel>(context, listen: false);

    // 선택된 연도 및 월 초기화
    selectedYear = AppString.total; // 기본값을 '전체'로 설정
    selectedText = AppString.total; // 기본값을 '전체'로 설정
    selectedIndex = 0; // 기본값을 0으로 설정

    // 초기화 가능한 연도 목록과 월 목록을 가져오기
    availableYears = [];
    availableMonths = [AppString.total];

    // 필터링된 리스트를 비어있는 리스트로 초기화
    filteredArchiveList = [];

    loadMissionRecord();
  }

  // 데이터 로딩 함수
  Future<void> loadMissionRecord() async {
    await viewModel.getMissionRecord(widget.id); // id 전달
    setState(() {
      missionRecord = viewModel.missionRecord ??
          missionRecord; // missionRecord가 null이면 빈 값으로 대체
      availableYears =
          CommonUtils.extractAvailableYears(missionRecord.archiveList);
      selectedYear = availableYears.isNotEmpty ? availableYears.first : "2025년";
      availableMonths = CommonUtils.extractAvailableMonths(
          missionRecord.archiveList, selectedYear);
      filteredArchiveList = CommonUtils.filterArchiveList(
          missionRecord.archiveList, selectedYear, selectedText);
    });
  }

  void updateYear(String newYear) {
    setState(() {
      selectedYear = newYear;
      selectedIndex = 0;
      selectedText = AppString.total;
      availableMonths = CommonUtils.extractAvailableMonths(
          missionRecord.archiveList, selectedYear);
      filteredArchiveList = CommonUtils.filterArchiveList(
          missionRecord.archiveList, selectedYear, selectedText);
    });
  }

  void updateMonth(int index) {
    setState(() {
      selectedIndex = index;
      selectedText =
          index == 0 ? AppString.total : "${index}월"; // 0은 '전체', 나머지는 1~12월
      filteredArchiveList = CommonUtils.filterArchiveList(
          missionRecord.archiveList, selectedYear, selectedText);
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
                      ImageMissionGameInformation(gameData: missionRecord),
                    ],
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondaryBlack,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: mainWhite,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
                      SvgPicture.asset(IconPath.arrowDown),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 달 선택
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(13, (index) {
                      // 0번째는 '전체', 1~12번째는 1월~12월
                      String text = index == 0 ? AppString.total : "$index월";
                      bool isSelected = selectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextButton(
                          onPressed: () => updateMonth(index),
                          style: ButtonStyle(
                            // padding:
                            //     MaterialStateProperty.all(EdgeInsets.all(10)),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8)),
                            minimumSize: MaterialStateProperty.all(Size(0, 0)),
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
                            AppString.noMissionReport,
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
