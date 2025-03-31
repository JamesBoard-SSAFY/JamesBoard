import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/widget/button/ButtonCommonGameTag.dart';
import '../../../../datasource/model/response/MyPage/MyPageArchiveResponse.dart';
import '../../../../util/CommonUtils.dart';

class ItemUserArchiveCard extends StatelessWidget {
  final List<MyPageArchiveResponse> missionDataList;

  const ItemUserArchiveCard({super.key, required this.missionDataList});

  @override
  Widget build(BuildContext context) {
    // 월별로 그룹화된 데이터
    Map<String, List<MyPageArchiveResponse>> groupedData = {};

    // missionDataList를 월별로 그룹화
    for (var missionData in missionDataList) {
      String month = CommonUtils.extractMonth(missionData.createdAt);
      if (groupedData.containsKey(month)) {
        groupedData[month]!.add(missionData);
      } else {
        groupedData[month] = [missionData];
      }
    }

    return Column(
      children: groupedData.entries.map((entry) {
        String month = entry.key;
        List<MyPageArchiveResponse> items = entry.value;

        // 월별 텍스트와 해당 월에 속하는 아이템들 출력
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  month, // 월을 상단에 출력
                  style: TextStyle(
                    fontSize: 24,
                    color: mainWhite,
                    fontFamily: FontString.pretendardSemiBold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),

            // 아이템들 출력
            Padding(
              padding: const EdgeInsets.only(left: 34),
              child: Column(
                children: items.map((missionData) {
                  String day =
                  CommonUtils.extractDay(missionData.createdAt);
                  String dayOfWeek = CommonUtils.extractDayOfWeek(
                      missionData.createdAt);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // 왼쪽 바깥에 텍스트 배치
                        Positioned(
                          left: -34,
                          child: Column(
                            children: [
                              Text(
                                day,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: mainWhite,
                                  fontFamily: FontString.pretendardMedium,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                dayOfWeek,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: mainWhite,
                                  fontFamily: FontString.pretendardMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 카드 위젯
                        IntrinsicHeight(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: mainGrey, width: 1),
                            ),
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    missionData.archiveImage,
                                    height: 300,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 16, bottom: 12),
                                  child: Column(
                                    children: [
                                      Text(
                                        missionData.archiveContent,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: mainWhite,
                                          fontFamily:
                                          FontString.pretendardMedium,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            ButtonCommonGameTag(
                                                text:
                                                '${missionData.archiveGamePlayCount}판'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
