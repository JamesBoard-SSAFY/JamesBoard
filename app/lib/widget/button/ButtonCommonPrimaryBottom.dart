import 'package:flutter/material.dart';
import 'package:jamesboard/theme/Colors.dart';

class ButtonCommonPrimaryBottom extends StatelessWidget {
  final String text;
  const ButtonCommonPrimaryBottom({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // 버튼 너비를 꽉 차게 설정
      child: IntrinsicHeight( // 버튼 높이를 내부 컨텐츠 크기에 맞게 조정
        child: ElevatedButton(
          onPressed: () {
            // 버튼 클릭 시 동작
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: secondaryBlack,
            padding: EdgeInsets.zero, // 기본 패딩 제거
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 기본 높이 제한 해제
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 22.5), // 내부 여백 조정
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: mainWhite,
                fontFamily: 'PretendardSemiBold',
              ),
            ),
          ),
        ),
      ),
    );
  }
}