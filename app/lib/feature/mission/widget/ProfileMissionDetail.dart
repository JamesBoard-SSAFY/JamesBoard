import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/feature/mission/widget/DialogMissionDetailDelete.dart';
import 'package:jamesboard/theme/Colors.dart';

class ProfileMissionDetail extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final int archiveUserId;
  final int loginUserId;

  const ProfileMissionDetail({
    super.key,
    required this.imageUrl,
    required this.userName,
    required this.archiveUserId,
    required this.loginUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // 프로필 사진
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(imageUrl),
            ),
            SizedBox(width: 12),

            // 사용자 이름
            Text(
              userName,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: FontString.pretendardMedium,
                  color: mainWhite),
            )
          ],
        ),

        // 더보기
        if (loginUserId == archiveUserId)
          GestureDetector(
            onTap: () => {_onMorePressed(context)},
            child: SvgPicture.asset(
              IconPath.more,
              width: 24,
              height: 24,
              color: mainWhite,
            ),
          ),
      ],
    );
  }

  void _onMorePressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              color: secondaryBlack,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 수정 버튼
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: mainGrey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryBlack,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      elevation: 0,
                    ),
                    child: Text(
                      AppString.update,
                      style: TextStyle(
                        color: mainWhite,
                        fontSize: 20,
                        fontFamily: FontString.pretendardBold,
                      ),
                    ),
                  ),
                ),

                // 삭제 버튼
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();

                      Future.delayed(const Duration(milliseconds: 100), () {
                        showCustomDialogMissionDetailDelete(
                            context,
                            AppString.missionDialogMainMessage,
                            AppString.missionDialogSubMessage);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryBlack,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      elevation: 0,
                    ),
                    child: Text(
                      AppString.delete,
                      style: TextStyle(
                        color: mainWhite,
                        fontSize: 20,
                        fontFamily: FontString.pretendardBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
