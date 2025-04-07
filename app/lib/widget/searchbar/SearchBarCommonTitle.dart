import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';

class SearchBarCommonTitle extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const SearchBarCommonTitle({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLength: 50,
              controller: controller,
              onSubmitted: onSubmitted,
              style: TextStyle(
                fontFamily: FontString.pretendardMedium,
                color: mainWhite, // 텍스트 색상 설정
                fontSize: 16,
              ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: AppString.searchBarHint,
                  hintStyle: TextStyle(
                    fontFamily: FontString.pretendardMedium,
                    color: mainGrey,
                    fontSize: 16,
                  ),
                  counterText: '',
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
              Navigator.pop(context);
            },
            child: Text(
              AppString.cancel,
              style: TextStyle(
                  color: mainWhite,
                  fontSize: 16,
                  fontFamily: FontString.pretendardMedium),
            ),
          ),
        ],
      ),
    );
  }
}
