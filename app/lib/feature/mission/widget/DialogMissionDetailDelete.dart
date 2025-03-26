import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamesboard/feature/mission/widget/ButtonMissionDetailDialog.dart';
import 'package:jamesboard/theme/Colors.dart';

import '../../../main.dart';

class DialogMissionDetailDelete extends StatelessWidget {
  final String mainMessage;
  final String subMessage;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DialogMissionDetailDelete({
    super.key,
    required this.mainMessage,
    required this.subMessage,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 처리
        GestureDetector(
          onTap: onCancel,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            width: double.infinity,
            height: double.infinity,
          ),
        ),

        // 다이얼로그
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.90,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: secondaryBlack,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: mainGold,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 메인 메시지
                Text(
                  mainMessage,
                  style: TextStyle(
                    color: mainWhite,
                    fontSize: 20,
                    fontFamily: 'PretendardSemiBold',
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 20),

                // 서브 메시지
                Text(
                  subMessage,
                  style: TextStyle(
                    color: mainWhite,
                    fontSize: 16,
                    fontFamily: 'PretendardSemiBold',
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 32),

                // 버튼들
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 취소
                    Expanded(
                      child: ButtonMissionDetailDialog(
                        text: '취소',
                        onPressed: onCancel,
                      ),
                    ),

                    const SizedBox(width: 20),

                    // 확인
                    Expanded(
                      child: ButtonMissionDetailDialog(
                        text: '확인',
                        onPressed: onConfirm,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

Future<void> showCustomDialogMissionDetailDelete(
    BuildContext context, String mainMessage, String subMessage) async {
  bool? result = await showGeneralDialog(
    context: context,
    barrierDismissible: true, // 바깥 영역 탭 시 닫기
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.5), // 배경 어둡게
    pageBuilder: (context, animation, secondaryAnimation) {
      return DialogMissionDetailDelete(
        mainMessage: mainMessage,
        subMessage: subMessage,
        onConfirm: () {
          Navigator.of(context).pop(true);
        },
        onCancel: () {
          Navigator.of(context).pop(false);
        },
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      // 페이드 인 & 팝업 애니메이션 추가
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: child,
        ),
      );
    },
  );

  if (result == true) {
    // 확인 버튼 처리
    print('확인이 눌림');
  } else {
    // 취소 버튼 처리
    print('취소가 눌림');
  }
}
