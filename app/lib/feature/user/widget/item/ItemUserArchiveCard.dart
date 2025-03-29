import 'package:flutter/material.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:jamesboard/widget/button/ButtonCommonGameTag.dart';

import '../../../../util/CommonUtils.dart';

class ItemUserArchiveCard extends StatelessWidget {
  final Map<String, dynamic> missionData;

  const ItemUserArchiveCard({super.key, required this.missionData});

  @override
  Widget build(BuildContext context) {
    String day = CommonUtils.extractDay(missionData['date'] ?? '');
    String dayOfWeek = CommonUtils.extractDayOfWeek(missionData['date'] ?? '');

    return Padding(
      padding: const EdgeInsets.only(left: 34), // 왼쪽 여백 확보
      child: Stack(
        clipBehavior: Clip.none, // 바깥 요소가 잘리지 않도록 설정
        children: [
          // 왼쪽 바깥에 텍스트 배치
          Positioned(
            left: -34, // 카드의 왼쪽 바깥으로 이동
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
                      missionData['img'] ?? '',
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
                          missionData['content'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: mainWhite,
                            fontFamily: FontString.pretendardMedium,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ButtonCommonGameTag(
                                  text: '${missionData['tag'] ?? 0}판'),
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
  }
}
