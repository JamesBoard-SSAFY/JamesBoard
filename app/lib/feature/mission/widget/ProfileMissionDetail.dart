import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/feature/mission/viewmodel/MissionViewModel.dart';
import 'package:jamesboard/feature/mission/widget/DialogMissionDetailDelete.dart';
import 'package:jamesboard/theme/Colors.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class ProfileMissionDetail extends StatefulWidget {
  final String imageUrl;
  final String userName;
  final int archiveUserId;
  final int loginUserId;
  final int archiveId;
  final VoidCallback? onDeleteSuccess;

  const ProfileMissionDetail({
    super.key,
    required this.imageUrl,
    required this.userName,
    required this.archiveUserId,
    required this.loginUserId,
    required this.archiveId,
    this.onDeleteSuccess,
  });

  @override
  State<ProfileMissionDetail> createState() => _ProfileMissionDetailState();
}

class _ProfileMissionDetailState extends State<ProfileMissionDetail> {
  void _onMorePressed(BuildContext context) {
    final parentContext = context;

    showModalBottomSheet(
      context: parentContext,
      backgroundColor: secondaryBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 수정 버튼
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(parentContext).pop();
                  // TODO: 수정 이동
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: secondaryBlack,
                ),
                child: Text(
                  AppString.update,
                  style: TextStyle(
                    color: mainWhite,
                    fontSize: 18,
                    fontFamily: FontString.pretendardBold,
                  ),
                ),
              ),
            ),

            // 구분선
            const Divider(color: mainGrey, height: 1),

            // 삭제 버튼
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  Navigator.of(parentContext).pop();
                  await Future.delayed(const Duration(milliseconds: 100));

                  final result = await showCustomDialogMissionDetailDelete(
                    parentContext,
                    AppString.missionDialogMainMessage,
                    AppString.missionDialogSubMessage,
                  );

                  if (result == true) {
                    logger.d('✅ onConfirm 실행됨');

                    if (!mounted) return;

                    final viewModel = parentContext.read<MissionViewModel>();
                    final deleteResult =
                        await viewModel.deleteArchive(widget.archiveId);

                    logger.d('🧨 삭제 결과: $deleteResult');

                    if (!mounted) return;

                    if (deleteResult != -1) {
                      if (widget.onDeleteSuccess != null) {
                        widget.onDeleteSuccess!();
                      }
                    } else {
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        const SnackBar(content: Text('삭제에 실패했습니다.')),
                      );
                    }
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: secondaryBlack,
                ),
                child: Text(
                  AppString.delete,
                  style: TextStyle(
                    color: Colors.red[500],
                    fontSize: 18,
                    fontFamily: FontString.pretendardBold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(widget.imageUrl),
            ),
            const SizedBox(width: 12),
            Text(
              widget.userName,
              style: TextStyle(
                fontSize: 16,
                fontFamily: FontString.pretendardMedium,
                color: mainWhite,
              ),
            ),
          ],
        ),
        if (widget.loginUserId == widget.archiveUserId)
          GestureDetector(
            onTap: () => _onMorePressed(context),
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
}
