import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/theme/Colors.dart';

class SearchBarCommonTitle extends StatelessWidget {
  const SearchBarCommonTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(
                fontFamily: 'PretendardMedium',
                color: mainWhite, // 텍스트 색상 설정
              ),
              decoration: InputDecoration(
                hintText: "어떤 보드게임을 찾으시나요?",
                hintStyle: TextStyle(
                  fontFamily: 'PretendardMedium',
                  color: mainGrey
                ),
                filled: true,
                fillColor: secondaryBlack,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 30,
                  color: mainGrey
                )
              ),
            ),
          ),
          SizedBox(width: 1),
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
            child: Text(
              "취소",
              style: TextStyle(
                color: mainWhite,
                fontSize: 18,
                fontFamily: 'PretendardSemiBold'
              ),
            ),
          ),
        ],
      ),
    );
  }
}