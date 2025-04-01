import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
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
                fontFamily: FontString.pretendardMedium,
                color: mainWhite, // 텍스트 색상 설정
              ),
              decoration: InputDecoration(
                  hintText: AppString.searchBarHint,
                  hintStyle: TextStyle(
                      fontFamily: FontString.pretendardMedium, color: mainGrey),
                  filled: true,
                  fillColor: secondaryBlack,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search, size: 30, color: mainGrey)),
            ),
          ),
          SizedBox(width: 1),
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
            child: Text(
              AppString.cancel,
              style: TextStyle(
                  color: mainWhite,
                  fontSize: 18,
                  fontFamily: FontString.pretendardSemiBold),
            ),
          ),
        ],
      ),
    );
  }
}
