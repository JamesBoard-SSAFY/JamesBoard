import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';

class ItemCommonGameRank extends StatelessWidget {
  const ItemCommonGameRank({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: secondaryBlack,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        clipBehavior: Clip.none, // Stack 내에서의 크기 초과를 허용
        children: [
          ListTile(
            leading: ClipOval(
              // ClipOval을 이용해 원형으로 만듦
              child: Image.asset(
                IconPath.bangImage,
                width: 50,
                height: 50,
                fit: BoxFit.cover, // 이미지 비율 유지
              ),
            ),
            title: Text(
              "부루마블",
              style: TextStyle(
                fontSize: 20,
                fontFamily: FontString.pretendardSemiBold,
                color: mainWhite,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  IconPath.time,
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 8),
                Text(
                  "35분",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: FontString.pretendardSemiBold,
                    color: mainWhite,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: -10, // 부모 컨테이너의 padding 값을 고려하여 조정
            bottom: -20,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 테두리 효과
                  Text(
                    '100',
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: FontString.pretendardSemiBold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = mainGold,
                    ),
                  ),
                  // 안쪽 텍스트 색상
                  Text(
                    '100',
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: FontString.pretendardSemiBold,
                      color: mainRed,
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
